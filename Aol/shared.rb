def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\aol_captcha.png"
  obj = @browser.image( :xpath, '//*[@id="regImageCaptcha"]' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def enter_captcha( errorField, button, textField)

	capSolved = false
	count = 1
	until capSolved and count > 5 do
		captcha_code = solve_captcha
		textField.set captcha_code
		button.click

		if not errorField == 'Please correct this field.'
			capSolve = true
		end
	count+=1	
	end

	if capSolve == true
		true
	else
		throw("Captcha was not solved")
	end
end
