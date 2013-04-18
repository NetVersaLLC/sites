def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\askyp_captcha.png"
  obj = @browser.img( :xpath, '/html/body/form/font/img' )
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
		@browser.text_field( :id, 'security_try').set captcha_code
		@browser.button(:value => 'Submit').click
		
		if not @browser.text.include? "You Enter incorrect image text Please re-enter correct image text"
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

