def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\showinusa_captcha.png"
  obj = @browser.img( :xpath, '/html/body/form/div[3]/div[3]/div/div[3]/div/div/table/tbody/tr[2]/td[2]/div/img' )
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
		@browser.button( :id => 'ctl00_MainContent_submitButton').click
	
		sleep(2)
		if not @browser.text.include? "Please enter the two words you see here into the box below it. It is not case sensitive"
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
