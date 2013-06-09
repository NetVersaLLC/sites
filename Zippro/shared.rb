def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\zippro_captcha.png"
  obj = @browser.img( :class, 'verif_image' )
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
		@browser.text_field( :id, 'captcha').when_present.set captcha_code.upcase
		@browser.button( :title => 'Finish').when_present.click	
		sleep(4)
		if not @browser.text.include? "Invalid verification code"
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

def enter_captcha2( data )
	error = false
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		@browser.text_field( :id => 'f_name').when_present.set data['fname']
		@browser.text_field( :id => 'l_name').set data['lname']
		@browser.text_field( :id => 'email').set data['email']
		@browser.text_field( :id => 'v_email').set data['email']
		@browser.text_field( :id => 'password').set data['password']
		@browser.text_field( :id => 'c_password').set data['password']
		captcha_code = solve_captcha	
		@browser.text_field( :id, 'captcha').when_present.set captcha_code.upcase
		@browser.checkbox( :id => 'agree').set
		@browser.button( :class => 'signup').when_present.click	
		sleep(4)
		if @browser.text.include? "Email is already in use. Please enter another email."
			puts("Error: Email Already In Use")
			error = true
			break
		end
		if not @browser.text.include? "Incorrect Verification code."
			capSolved = true
		end
	count+=1
	end
	if error == true
		break
	end
	if capSolved == true
		true
	else
		throw("Captcha was not solved")
	end
end


def sign_in(data)
	@browser.goto("http://myaccount.zip.pro/login.php?type=bo")
	@browser.text_field(:id => 'email').set data['email']
	@browser.text_field(:id => 'password').set data['password']
	@browser.button(:id => 'userLoginBtn').click

end
