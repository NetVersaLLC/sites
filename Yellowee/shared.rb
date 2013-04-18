def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\yellowee_captcha.png"
  obj = @browser.img( :xpath, '/html/body/div/div[4]/div/div/div/form/fieldset/div[8]/div/div/table/tbody/tr/td/center/div/img' )
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
		@browser.text_field( :id, 'recaptcha_response_field' ).set captcha_code
		@browser.text_field( :id => 'id_password1' ).set data[ 'password' ]
		@browser.text_field( :id => 'id_password2' ).set data[ 'password' ]
		@browser.button( :name => 'submit_new_user' ).click
		
		if not @browser.text.include? "The CAPTCHA solution was incorrect."
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

	@browser.goto( 'http://biz.yellowee.com/user/login?next=/steps/find-your-business' )
	@browser.text_field( :id => 'id_username' ).set data[ 'email' ]
	@browser.text_field( :id => 'id_password' ).set data[ 'password' ]
	@browser.button( :value => 'Login').click

end

