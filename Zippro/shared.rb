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
		@browser.text_field( :id, 'captcha').set captcha_code
		@browser.button( :title => 'Finish').click	
		sleep(2)
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
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha	
		@browser.text_field( :id, 'captcha').set captcha_code
		@browser.checkbox( :id => 'agree').set
		@browser.button( :class => 'signup').click	
		sleep(2)
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



def sign_in(data)
	@browser.goto("http://myaccount.zip.pro/login.php?type=bo")
	@browser.text_field(:id => 'email').set data['email']
	@browser.text_field(:id => 'password').set data['password']
	@browser.button(:id => 'userLoginBtn').click

end