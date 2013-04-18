def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\mojopages_captcha.png"
  obj = @browser.image( :xpath, "/html/body/div/div[3]/div[2]/div/div[2]/div[2]/div/div[3]/form/div[5]/div/div/div/table/tbody/tr[2]/td[2]/div/img" )
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
    @browser.text_field( :id, 'owner.password' ).set data[ 'personal_password' ]
		@browser.text_field( :xpath, '/html/body/div/div[3]/div[2]/div/div[2]/div[2]/div/div[3]/form/div[4]/div[12]/input' ).set data[ 'personal_password' ]
		@browser.text_field( :id, 'recaptcha_response_field').set captcha_code
		@browser.button( :value, 'Continue' ).click
		
		if not @browser.text.include? "Your text didn't match the image correctly."
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


def sign_in (data)
	@browser.goto("http://mojopages.com/login")
	@browser.text_field(:name => 'username').set data['email']
	@browser.text_field(:name => 'password').set data['password']
	@browser.button(:value => 'Login').click

end
