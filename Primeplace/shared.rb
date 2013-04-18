def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\primeplace_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="captchaImage"]' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha( data )
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha	
		@browser.text_field( :id, 'captcha').set captcha_code
		@browser.button( :id => 'submit').click	
		sleep(2)
		if not @browser.text.include? "The characters did not match the image. Please try again."
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

def sign_in( data )
@browser.goto( 'https://account.nokia.com/' )
@browser.text_field( :id => 'username').set data['username']
@browser.text_field( :id => 'password').set data['password']
@browser.button( :id => 'loginsubmit').click
end
