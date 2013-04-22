def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\findthebest_captcha.png"
  obj = @browser.image( :xpath, '//*[@id="recaptcha_image"]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha(thebox)

	capSolved = false
	count = 1
	until capSolved or count > 5 do
  		captcha_code = solve_captcha

		thebox.text_field( :id, 'recaptcha_response_field').set captcha_code
    	thebox.button( :id, 'edit-submit' ).click
		sleep(5)
		
		begin
			if not thebox.text_field( :id, 'recaptcha_response_field').exists?			
				capSolved = true
			end	
		rescue Timeout::Error
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


end