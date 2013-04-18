def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\gomylocal_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="captchaimg"]' )
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
		@browser.text_field( :id, '6_letters_code').set captcha_code	
		@browser.image( :src => '/images/submit_button.jpg').click
		sleep(2)
		if not @browser.alert.exists?
			capSolved = true
		else
			@browser.alert.ok
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
	@browser.goto("https://www.gomylocal.com/login.php")

	@browser.text_field(:name => 't1').set data['username']
	@browser.text_field(:name => 't2').set data['password']

	@browser.button(:value => 'login').click
	

end