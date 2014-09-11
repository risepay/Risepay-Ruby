require_relative 'risepays.rb'


class TestController
  def index
  	data ={}
    

    data['NameOnCard']= "Jhonny";
    data['CardNum']="5149612222222229";
    data['ExpDate']="1214";
    data['Amount']="22";
    data['CVNum']="678";
    data['InvNum']="ABC123";
    data['Zip']="33139";
    data['Street']="Gran vio 25";
    data['TipAmt']=1;

    @risepay = Risepays.new("demo","demo")


    @result =  @risepay.sale(data)


    def result_msg
      @message  
      if @result['Approved']
       @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +    "AuthCode = " + @result['AuthCode']
      else
       @message =  "Declined " + @result['Message']

      end	
      return @message

    end

   @msg = result_msg()

  end

end
