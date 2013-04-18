def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\matchpoint_captcha.png"
  obj = @browser.img( :xpath, '/html/body/div/div[2]/div[2]/form/div/div[13]/div[2]/img' )
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
		@browser.text_field( :name => 'password').set data['password']
		@browser.text_field( :name => 'confirmedPassword').set data['password']
		@browser.text_field( :name, 'verifyWord').set captcha_code
		@browser.checkbox( :id => 'termCondition').click
		@browser.button( :type => 'submit').click
		sleep(2)
		if not @browser.text.include? "Word Verification do not match"
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



def solve_captcha2
  image = "#{ENV['USERPROFILE']}\\citation\\matchpoint_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="register"]/div[1]/div[5]/div[2]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha2( data )

	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha2
		@browser.text_field( :name => 'password').focus
		@browser.text_field( :name => 'password').set data['password']
		@browser.text_field( :name => 'passwordAgain').focus
		@browser.text_field( :name => 'passwordAgain').set data['password']
		@browser.text_field( :name, 'verifyWord').focus
		@browser.text_field( :name, 'verifyWord').set captcha_code
		
		@browser.button( :value => 'Create Account').click
		sleep(2)
		if not @browser.text.include? "Word Verification do not match"
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

