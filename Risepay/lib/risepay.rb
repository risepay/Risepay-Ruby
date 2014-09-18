=begin
 Risepay API helper

 @category  API helper
 @package   Risepay
 @author    support@risepay.com
 @copyright Copyright (c) 2014
 @version   1.0

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
=end

require 'uri'
require 'net/http'
require 'rubygems'
require 'ostruct'
require 'date'
require 'time'
require 'active_support'


class Risepays

	attr_accessor :UserName, :Password, :url, :defFileds, :info, :RespMSG, :formData, :resp


	def initialize(user,pass)
		@UserName = user;
		@Password = pass;
		@defFileds = ['TransType', 'NameOnCard','CardNum','ExpDate','Amount','CVNum','InvNum',
			'Zip','Street', 'MagData', 'Amount','PNRef'];

		@formData = [];
		@url ="https://gateway1.risepay.com/ws/transact.asmx/ProcessCreditCard"
		@amountFields = ['Amount', 'TipAmt', 'TaxAmt'];
		@resp = ''

	end 	

	def get_gateway_url()

		return @url 
	end

	def set_gateway_url(url)
		@url = url
	end

	def getDefFileds

		return @defFileds
	end

	def amountConvert(num)
		amount = '%.2f' % num
		return amount
	end


	def sale(opt = null)
		if opt

			@formData = opt

		end

		@formData["TransType"]="Sale"

		return prepare()

	end


	def auth(opt = null)

		if opt

			@formData = opt			
		end

		@formData["TransType"]="Auth"

		return prepare()

	end

	def returnTrans(opt = null)

		if opt

			@formData = opt
		end	

		@formData["TransType"]="Return"

		return prepare()
	end
	

	def void(opt = null)

		if opt

			@formData = opt
		end

		@formData["TransType"]="Void"

		return prepare()

	end

	def capture(opt = null)

		if opt		
			@formData = opt
		end	

		@formData["TransType"]="Force"

		return prepare()

	end

	def stringStartsWith(haystack, needle)
		return haystack.index(needle) === 0
	end

	def prepare()

		@data = {};
		@data["UserName"] = @UserName
		@data["Password"] = @Password
		@data["ExtData"] = ''

		#fix amounts
		@amountFields.each do |f|
			@amountFields[2] = ''
			if @formData[f]
				@formData[f] = amountConvert(@formData[f])
			end	
		end

		#Construct ExtData
		@formData.each do |f , value|
			if !((@defFileds).include? f)

				@data['ExtData']<< "<#{f}>#{value}</#{f}>";
				@formData.delete(f)
			else
				@data[f] = value;

			end
		end

		# set defaults fields
		@defFileds.each do |f|
			if @data[f] == 	nil
				@data[f] = '';
			end 
		end

		return post(@data)
		
	end

	def convert_response(obj)
		
		@resp = obj
		@resp['Approved'] = false

		#Add Approved Value
        if(@resp['Result'] == "0")
    		@resp['Approved']= true

			#ConvertExtData
			#Split plain data and XML into @matches hash
			matches = @resp['ExtData']
			matches = matches.match(/([,=0-9a-zA-Z]*)(\<.*\>)?/)
			@str = matches[1]

			#Process plain text coma separated keypairs
			@str.split(",").each do |f|
				arr = f.split('=');
				arr[1] && (@resp[arr[0]] = arr[1])
			end

	        #Process XML Part
	        if(matches.length == 2)
	        @xmldata = Hash.from_xml(matches[2])
	    	
	        
		        if @xmldata
		        	for x in @xmldata
		        		@resp[x] = @xmldata[x]
		        	end
		        end
		    end    

        end
        @jsonlist = ['xmlns:xsd', 'xmlns:xsi', 'xmlns', 'ExtData']
        
        @jsonlist.each do |j|
        	@resp.delete(j)

        end	


    	if(!@resp['Message'])
    		@resp['Message'] = "";
    	end

    	if(@resp['RespMSG'])
    		@resp['Message'] = @resp['Message'] + " " + @resp['RespMSG'];
    	end
    	  
        return @resp
	end


    def post(opts)

    	begin

	    	uri = URI.parse(@url)

	    	http = Net::HTTP.new(uri.host, uri.port)
	    	http.read_timeout = 120
	    	http.verify_mode = OpenSSL::SSL::VERIFY_PEER
	    	http.use_ssl = (uri.scheme == "https")
	    	request = Net::HTTP::Post.new(uri.request_uri)

	    	request.set_form_data(opts);

	    	response = http.request(request)
	    	xml= response.body
	    	session = Hash.from_xml(xml)
	    	res = session['Response']

	    	if (stringStartsWith(xml, "<?xml"))
	    		convert_response(res);
	    	else
	    		@resp['Result'] = -999
	    		@resp['Message'] = "Gateway error" + xml
	    		return @resp
	    	end

	    	return @resp
	    rescue Exception => e
	    	@resp['Result'] = -999
	    	@resp['Message'] = "Gateway error" + xml
	    	return @resp
	    end
    end

end
