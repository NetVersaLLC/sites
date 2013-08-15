def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\twitter_captcha.png"
  obj = @browser.div(:id => 'recaptcha_image').image()
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  CAPTCHA.solve image, :manual
end

def retry_captcha

	#retries = 5
	#solved = false
	#until solved == true or retries == 0
		@browser.text_field(:name => 'recaptcha_response_field').set solve_captcha
		@browser.button(:value => 'Create my account').click
		sleep 5
	#	if not @browser.text.include? "The text you entered didn't match the security check. Please try again."
	#		solved = true
	#	end
	#	if solved
	#		break
	#	end
	#end
end


def solve_captcha2
  image = "#{ENV['USERPROFILE']}\\citation\\twitter_captcha.png"
  obj = @browser.div(:id => 'recaptcha_image').image()
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  CAPTCHA.solve image, :manual
end

def retry_captcha2(data)

	#retries = 5
	#solved = false
	#until solved == true or retries == 0
		@browser.text_field(:name => 'recaptcha_response_field').set solve_captcha2
		@browser.h1(:text => 'Sign in to Twitter').click
		@browser.send_keys :tab
		@browser.send_keys :tab
		@browser.send_keys data['password'].split("")
		@browser.send_keys :enter
		sleep 5
	#	if not @browser.text.include? "The text you entered didn't match the security check. Please try again."
	#		solved = true
	#	end
	#	if solved
	#		break
	#	end
	#end
end


def sign_in(data)
	@browser.goto("https://twitter.com/login")

	@browser.h1(:text => 'Sign in to Twitter').click
	sleep 2
	@browser.send_keys :tab
	@browser.send_keys data['username']
	@browser.send_keys :tab
	@browser.send_keys :tab
	@browser.send_keys data['password']
	@browser.send_keys :enter
	sleep 2
	Watir::Wait.until { @browser.div(:id => 'tweet-box-mini-home-profile').exists?}

end