@browser.goto(data['url'])

	@browser.h1(:text => 'Sign in to Twitter').click
	sleep 2
	@browser.send_keys :tab
	@browser.send_keys data['username'].split("")
	@browser.send_keys :tab
	@browser.send_keys :tab
	@browser.send_keys data['password'].split("")
	@browser.send_keys :enter
	#@browser.button(:text => 'Sign in').click

retries = 5
begin
	#sleep 2
	#Watir::Wait.until { @browser.text.include? "We gotta check... are you human?" or @browser.text.include? "Your account has been confirmed. Thanks!"}
	30.times { break if (begin @browser.text.include? "We gotta check... are you human?" or @browser.text.include? "Your account has been confirmed. Thanks!" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

	if @browser.text.include? "We gotta check... are you human?"
		retry_captcha2(data)
	elsif @browser.text.include? "Your account has been confirmed. Thanks!"
		#Continue
	else
		raise "Error Verifying Twitter Email 1"
	end

		
	#Watir::Wait.until(10) { @browser.text.include? "Your account has been confirmed. Thanks!" }		
	10.times { break if (begin @browser.text.include? "Your account has been confirmed. Thanks!" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
	if @browser.text.include? "Your account has been confirmed. Thanks!"
		#Continue
	else
		raise "Error Verifying Twitter Email 2"
	end

rescue StandardError => e
	puts e.inspect
	if retries > 0
		retries -= 1
		retry
	else
		raise "Could not verify after 5 tries"
	end

end


if @chained
	self.start("Twitter/UpdateListing")
end

true