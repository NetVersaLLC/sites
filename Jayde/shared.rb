def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\jayde_captcha.png"
  obj = @browser.img( :xpath, '/html/body/div[5]/div[4]/div/form/table/tbody/tr[3]/td[2]/img' )
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
		@browser.text_field( :xpath, '/html/body/div[5]/div[4]/div/form/table/tbody/tr[3]/td[3]/input').set captcha_code
		@browser.button( :xpath => '/html/body/div[5]/div[4]/div/form/table/tbody/tr[7]/td/button').click
		sleep(3)
		if not @browser.text.include? "Your form had errors:"
			capSolved = true
		else
			@browser.image(:id => 'recaptcha_reload').click
		end		
	count+=1
	end
	if capSolved == true
		true
	else
		throw("Captcha was not solved")
	end
end

