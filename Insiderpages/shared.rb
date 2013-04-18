def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\insiderpages_captcha.png"
  obj = @browser.div( :id, 'recaptcha_image' ).image( :alt, "reCAPTCHA challenge image")
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
		@browser.checkbox( :id, 'terms_of_service').click
		@browser.text_field( :id, 'recaptcha_response_field').set captcha_code
		@browser.button(:value => 'submit').click
		
		if not @browser.text.include? "Please retype the text in the box to verify your submission"
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
	@browser.goto( 'http://www.insiderpages.com/session/new?header_link=true' )
	@browser.text_field( :id, 'friend_session_email').set data[ 'email' ]
	@browser.text_field( :id, 'friend_session_password').set data[ 'password' ]
	@browser.button( :value, 'sign in').click
end
