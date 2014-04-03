@browser = Watir::Browser.new :firefox
at_exit{
	unless @browser.nil?
		@browser.close
	end
}

def login(data)
  if not @browser.link(:text => 'Logout').exist?
  @browser.text_field(:id => 'email').set data['email']
  @browser.text_field(:id => 'pass').set data['password']
  @browser.button(:value => 'Log In').click 
  end
end

def solve_verify_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\facebook_captcha.png"
  if @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/).exists?
    obj = @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/)
  elsif @browser.image(:src, /recaptcha\/api\/image/).exists?
    obj = @browser.image(:src, /recaptcha\/api\/image/)
  else
    throw "A wild new captcha appears!"
  end
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def retry_verify_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_verify_captcha
    @browser.text_field(:name=> 'captcha_response').when_present.set captcha_text
    if @browser.button(:name =>'submit[Submit]').present?
    	@browser.button(:name =>'submit[Submit]').click
    elsif @browser.button(:name =>'submit[Continue]').present?
    	@browser.button(:name =>'submit[Continue]').click
    else
    	puts "Facebook has a new submission button."
    end

     sleep(5)
    if not @browser.text.include? "The text you entered didn't match the security check. Please try again."
      capSolved = true
    end
    count+=1
   end
  if capSolved == true
    true
  else
  throw("Captcha was not solved")
  end
end

def verify_phone(data)
	@browser.button(:name, "submit[Continue]").when_present.click
	sleep(3)
	Watir::Wait.until { @browser.text_field(:id, 'captcha_response').present? }
	retry_verify_captcha(data)
	sleep(1)
	@browser.span(:text, "Enter a phone number").click
	sleep(2)
	if @browser.text_field(:id, "ajax_password").exists?
		@browser.text_field(:id, "ajax_password").set data['password']
		sleep(2)
	end
	puts("Mobile: " + data['mobile'])
	@browser.text_field(:value, "Enter your number").send_keys data['mobile']
	sleep(1)
	@browser.button(:value, "1").click
	sleep(2)
	if @browser.text.include? "Please try a different number."
		raise("The phone number you're trying to verify was recently used to verify a different account. Please try a different number.")
	end
	retries = 5
	begin
		#sleep(60) #Bonus time for text to arrive
		code = PhoneVerify.retrieve_code('Facebook')
		puts("Code: " + code)
		@browser.text_field(:value, "Enter confirmation code").set code
		@browser.button(:value, "1").click
		Watir::Wait.until(120) { @browser.text.include? "Thanks for confirming your phone number" }
		@browser.button(:value, "1").click
		sleep(5)
		puts("Phone Verification Successful!")
		if @chained
			self.start("Facebook/CreateListing")
			true
		end
	rescue
		if retries > 0
			if @browser.text.include? "Enter Your Confirmation Code"
				puts("Code not entered! Retrying...")
				retry
				retries -= 1
			elsif @browser.text.include? "Invalid confirmation code"
				puts("Invalid Code")
				PhoneVerify.wrong_code('Facebook')
				retry
				retries -= 1
			end
		else
			raise("Phone Verification Failure - Could not enter code")
		end
	end
end
@browser.goto("www.facebook.com")
login(data)
verify_phone(data)
