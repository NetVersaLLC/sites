def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\freebusinessdirectory_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="validn_img"]' )
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
		@browser.text_field( :name => 'pass1' ).set data[ 'password' ]
		@browser.text_field( :name => 'pass2' ).set data[ 'password' ]	
		@browser.text_field( :id, 'validn_code').set captcha_code
		@browser.button(:id => 'newcompany').click
		
		if not @browser.text.include? "Incorrect validation code. Please try again"
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
