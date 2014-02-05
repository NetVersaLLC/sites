@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

url = 'https://www.getfave.com/login'
@browser.goto url

@browser.link(:text,'create a new one,').click

@browser.text_field(:id,'user_name').set data[ 'name' ]
@browser.text_field(:id,'user_email').set data[ 'email' ]
@browser.text_field(:id,'user_password').set data[ 'password' ]
@browser.button(:value,'Join Us').click

if @browser.text.include? 'Email is already taken'
	self.failure("Email already registered.")
elsif @browser.text.include? "can't be blank"
	self.failure("Required fields can not be blank.") 
elsif @browser.label(:class, "error").present?
	throw "There is an error while creating the account"	
else 
	self.save_account("Getfave", {:email => data['email'], :password => data['password']})
	self.save_account("Getfave", {:status => "Account created, verifying account..."})
	puts "Signup successful. Verifying email to continue"
	if @chained
  		self.start("Getfave/Verify")
	end
	self.success
end
