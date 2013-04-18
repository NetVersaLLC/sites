def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\supermedia_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="captchimgid"]' )
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
		@browser.text_field( :id, 'captchaRes').set captcha_code	
		@browser.link( :text => 'continue').click
	
		sleep(2)
		if not @browser.text.include? "Please try again. Entry did not match display."
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
	@browser.goto("http://www.supermedia.com/")
	@browser.link(:text => 'CLIENT SIGN IN').click

	Watir::Wait.until { @browser.text_field(:id => 'uname').exists? }

	@browser.text_field(:id => 'uname').set data['email']
	@browser.text_field(:id => 'password').set data['password']

	@browser.td(:text => 'sign in').click

end