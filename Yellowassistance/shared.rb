def sign_in(data)
	@browser.goto("http://www.yellowassistance.com/")
	@browser.link(:text => 'Login').click
	sleep 2
	@browser.text_field(:id => 'Login1_txtLoginEmail').set data['email']
	@browser.text_field(:id => 'Login1_txtLoginPass').set data['password']
	@browser.button(:id => 'btnLogin').click


end

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\yellowassistance_captcha.png"
  obj = @browser.image( :xpath, '//*[@id="imgCode"]' )
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
		  
			@browser.text_field( :id => 'txtPassword' ).set data[ 'password' ]	
			@browser.text_field( :name => 'txtRegCode' ).set captcha_code
			@browser.button( :name => 'btnValidate' ).click
			sleep 3
		if not @browser.text.include? "code does not match"
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