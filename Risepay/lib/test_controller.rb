require_relative 'risepays.rb'

class TestController

  attr_accessor :risepay, :data, :result, :msg

  def initialize
    @data ={}
    
    @data['NameOnCard']= "Jhonny";
    @data['CardNum']="5149612222222229";
    @data['ExpDate']="1214";
    @data['Amount']="22";
    @data['CVNum']="678";

    @risepay = Risepays.new("demo","demo")

    @result =''
    @msg = ''
    #Call your transaction type
    sale_void(@data)

  end

  def result_msg
    @message
    if @result['Approved']
      @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +    "AuthCode = " + @result['AuthCode']

    else
      @message =  "Declined " + @result['Message']

    end 

    return @message
  end

    #Return a Sale transaction
  def sale(data)

    @result =  @risepay.sale(data)

    result_msg()

  end

  #Return a Void transaction
  def sale_void(data)

    @sale =  @risepay.sale(data)
    data['PNRef'] = @sale['PNRef']  

    @result  = @risepay.void(data)
    result_msg()
  end

  #Return a Auth transaction
  def auth(data)
  
    @result = @risepay.auth(data)
    result_msg()
  end

  #Return a Capture transaction
  def auth_capture(data)
    @auth =  @risepay.auth(data)
    data['PNRef'] = @auth['PNRef']  

    @result  = @risepay.capture(data)
    result_msg()
  end  

  #Return a "Return" transaction
  def sale_return(data)

    @sale =  @risepay.sale(data)
    data['PNRef'] = @sale['PNRef']  

    @result  = @risepay.returnTrans(data)
    result_msg()
  end  

end

