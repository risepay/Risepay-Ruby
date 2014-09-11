RisePay-Ruby -- Simple Risepay Payment API wrapper

A Ruby module for interacting with the RisePay API

<hr>

You can request developer credentials from our <a href='http://sales.risepay.com/rise-dev-access.html'>Dev Portal</a>.</br> If you would like to certify your application, then submit a <a href='http://sales.risepay.com/rise-cert-lab-access.html'>Cert Lab request</a>.
<hr>

<hr>
### Table of Contents
**[Initialization](#initialization)**

**[Sale Transaction](#sale-transaction)**

**[Auth Transaction](#authorization-transaction)**

**[Void Transaction](#void-transaction)**

**[Return Transaction](#return-transaction)**

**[Capture Transaction](#capture-transaction)**

### Initialization

To utilize, install <a href="http://rubyonrails.org/download/">ruby on rails</a>
  
  gem install rails

  
### Sale Transaction
To make a purchase using a credit card:

Functional API:

```ruby

@risepay = Risepays.new("demo","demo")

data['NameOnCard']= "John Doe";
data['CardNum']="4111111111111111";
data['ExpDate']="1215";
data['Amount']="10";
data['CVNum']="734";

@result =  @risepay.sale(data)

def result_msg
 @message
	  if @result['Approved']
	    @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  + 
	    "AuthCode = " + @result['AuthCode']
	  else
	    @message =  "Declined " + @result['Message']
	  end	

	return @message
end

@msn = result_msg()
```

### Authorization Transaction
To make an authorization using a credit card:

Functional API:
  
```ruby

@risepay = Risepays.new("demo","demo")

data['NameOnCard']= "John Doe";
data['CardNum']="4111111111111111";
data['ExpDate']="1215";
data['Amount']="10";
data['CVNum']="734";

@result =  @risepay.auth(data)

def result_msg
 @message
	  if @result['Approved']
	    @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +  
	    "AuthCode = " + @result['AuthCode']
	  else
	    @message =  "Declined " + @result['Message']
	  end	

	return @message
end

@msn = result_msg()
```
  
### Void Transaction

To void a transaction:

Functional API:

```ruby

@risepay = Risepays.new("demo","demo")

data['NameOnCard']= "John Doe";
data['CardNum']="4111111111111111";
data['ExpDate']="1215";
data['Amount']="10";
data['CVNum']="734";
data['PNRef'] = "24324";

@result =  @risepay.void(data)

def result_msg
 @message
	  if @result['Approved']
	    @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +   
	    "AuthCode = " + @result['AuthCode']
	  else
	    @message =  "Declined " + @result['Message']
	  end	

	return @message
end

@msn = result_msg()
```
  
### Capture Transaction

To capture a previously Authorized transaction:

Functional API:

  ```ruby

@risepay = Risepays.new("demo","demo")

data['NameOnCard']= "John Doe";
data['CardNum']="4111111111111111";
data['ExpDate']="1215";
data['Amount']="10";
data['CVNum']="734";
data['PNRef'] = "24324";

@result =  @risepay.capture(data)

def result_msg
 @message
	  if @result['Approved']
	    @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +   
	    "AuthCode = " + @result['AuthCode']
	  else
	    @message =  "Declined " + @result['Message']
	  end	

	return @message
end

@msn = result_msg()
```

### Return Transaction

To return a payment for already batched transaction:

Functional API:

 ```ruby

@risepay = Risepays.new("demo","demo")

data['NameOnCard']= "John Doe";
data['CardNum']="4111111111111111";
data['ExpDate']="1215";
data['Amount']="10";
data['CVNum']="734";
data['PNRef'] = "24324";

@result =  @risepay.return_trans(data)

def result_msg
 @message
	  if @result['Approved']
	    @message = "Approved. Transaction ID = " + @result['PNRef'] +  "\n"  +   
	    "AuthCode = " + @result['AuthCode']
	  else
	    @message =  "Declined " + @result['Message']
	  end	

	return @message
end

@msn = result_msg()
```

To see complete list of an extra RisePay API variables, take a look at their <a href='https://gateway1.risepay.com/vt/nethelp/Documents/processcreditcard.htm'>documentation</a>.
