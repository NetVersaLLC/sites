def solve_captcha	
  image = "#{ENV['USERPROFILE']}\\citation\\digabusiness_captcha.png"
  puts("image saved?")
  obj = @browser.img( :title, 'Visual Confirmation Security Code' )
  puts("image saved.")
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
	puts("About to solve the code")
  CAPTCHA.solve image, :manual
end

def enter_captcha( data )
	puts("Is this called?")
	capSolved = false
	count = 1
	until capSolved or count > 5 do

		captcha_code = solve_captcha

		puts(captcha_code)
		@browser.text_field( :id => 'CAPTCHA').set captcha_code
		@browser.button( :name => 'submit').click
		sleep(2)
		if not @browser.text.include? "Invalid code."
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


def solve_captcha_signup
  image = "#{ENV['USERPROFILE']}\\citation\\digabusiness_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="padding"]/form/table/tbody/tr[8]/td[2]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"

  obj.save image
  CAPTCHA.solve image, :manual
end

def enter_captcha_signup( data )
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha_signup	
		@browser.text_field( :id => 'CAPTCHA').set captcha_code
		@browser.button( :name => 'submit').click
		sleep(2)
		if not @browser.text.include? "Invalid code."
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
	@browser.goto("http://www.digabusiness.com/login.php")
	@browser.text_field(:name => 'user').set data['email']
	@browser.text_field(:name => 'pass').set data['password']
	@browser.button(:name => 'submit').click
end

