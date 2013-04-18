def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\adsolutionsyp_captcha.png"
  obj = @browser.image(:xpath => '//*[@id="captchaRow"]/div[2]/div[2]/img')
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha
		@browser.text_field( :id, 'captcha').set captcha_code
		@browser.button(:src => 'https://si.yellowpages.com/D49_ascp-btn-cont-blue_V1.png').click
		
		if not @browser.text.include? "Please enter the same text as the image."
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
	@browser.goto("https://adsolutions.yp.com/SSO/Login")
	@browser.text_field(:id => 'Email').set data['email']
	@browser.text_field(:id => 'Password').set data['password']
	@browser.button(:src => 'https://si.yellowpages.com/D49_ascp-button-signup-blue_V1.png').click
	sleep 2
end
