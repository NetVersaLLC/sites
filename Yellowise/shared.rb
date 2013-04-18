def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\freebusinessdirectory_captcha.png"
  obj = @browser.img( :xpath, '/html/body/div/form/table/tbody/tr[6]/td/div/img' )
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
		@browser.text_field( :id, 'recaptcha_response_field').set captcha_code
		@browser.checkbox( :id => 'tc').click
		@browser.button(:text => 'Sign Up').click
		
		if not @browser.text.include? "Your confirmation code does not match the one in the image."
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

	@browser.text_field( :id => 'login').set data[ 'username' ]
	@browser.text_field( :id => 'password').set data[ 'password' ]
	@browser.button( :text => 'Sign In').click

end
