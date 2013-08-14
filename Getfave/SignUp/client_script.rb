# Launch url
url = 'https://www.getfave.com'
@browser.goto url
#Verify if the page is loaded successfully.
30.times{break if (begin @browser.link(:text, "Log In/Join").present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1}

sign_in data
30.times{break if (begin @browser.button(:name, "commit").present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1}

#~ throw("Login unsuccessful") if @sign_in.exist?

# Check for login error
@login_error = @browser.div(:class,'container error')

#Sign up if user doesn't exist
if @login_error.exist? 
	@browser.link(:text,'create a new one,').click
	@browser.text_field(:id,'user_name').set data[ 'name' ]
	@browser.text_field(:id,'user_email').set data[ 'email' ]
	@browser.text_field(:id,'user_password').set data[ 'password' ]
	@browser.button(:value,'Join Us').click
end

if @browser.text.include? 'Please correct the errors and try again.'
	throw "There is an error while creating the account"
end

sleep 4
30.times{break if (begin @browser.link(:text, "Log In/Join").present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1}

self.save_account("Getfave", {:email => data['email'], :password => data['password']})
	puts "Signup successful. Verifying email to continue"

	
if @chained
  self.start("Getfave/Verify")
end

true
