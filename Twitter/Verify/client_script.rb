@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def solve_captcha2
  image = "#{ENV['USERPROFILE']}\\citation\\twitter_captcha.png"
  obj = @browser.img(:src => /recaptcha/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  CAPTCHA.solve image, :manual
end

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
		@browser.text_field(:name => 'recaptcha_response_field').set solve_captcha2
		@browser.h1(:text => 'Sign in to Twitter').click
		@browser.send_keys :tab
		@browser.send_keys :tab
		@browser.send_keys data['password'].split("")
		@browser.send_keys :enter
		sleep 5
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