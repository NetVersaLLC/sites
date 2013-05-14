@browser.goto(data['url'])

	@browser.h1(:text => 'Sign in to Twitter').click
	sleep 2
	@browser.send_keys :tab
	@browser.send_keys data['username'].split("")
	@browser.send_keys :tab
	@browser.send_keys data['password'].split("")
	@browser.send_keys :enter
	#@browser.button(:text => 'Sign in').click

retries = 5
begin
	sleep 2
	Watir::Wait.until { @browser.text.include? "We gotta check... are you human?" or @browser.text.include? "Your account has been confirmed. Thanks!"}

	if @browser.text.include? "We gotta check... are you human?"
		retry_captcha2(data)
	end

		
	Watir::Wait.until(10) { @browser.text.include? "Your account has been confirmed. Thanks!" }		


rescue Exception => e
	puts e.inspect
	if retries > 0
		retries -= 1
		retry
	else
		raise "Could not verify after 5 tries"
	end

end


true