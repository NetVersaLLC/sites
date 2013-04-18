def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\localndex_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="ctl00_ContentPlaceHolder1_imgCaptcha"]' )
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
		#if @browser.text_field(:id => 'ctl00_ContentPlaceHolder1_txtPassword').exists?
			#@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']
		#end
		@browser.text_field( :id, 'ctl00_ContentPlaceHolder1_txtSecurity' ).set captcha_code
		@browser.button( :type => 'submit' ).click
		
		if not @browser.text.include? "Wrong match!"
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


def solve_captcha2
  image = "#{ENV['USERPROFILE']}\\citation\\localndex_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="ctl00_ContentPlaceHolder1_imgCaptcha"]' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha2( data )

	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha	
		
			@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']
		
		@browser.text_field( :id, 'ctl00_ContentPlaceHolder1_txtSecurity' ).set captcha_code
		@browser.button( :type => 'submit' ).click
		
		if not @browser.text.include? "Wrong match!"
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
