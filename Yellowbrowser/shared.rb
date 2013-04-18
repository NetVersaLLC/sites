def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\yellowbrowser_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="phoca-captcha"]' )
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
		@browser.text_field( :id, 'captcha').set captcha_code
		@browser.button( :index => 0).fire_event('onkeydown')
		@browser.button( :index => 0).fire_event('onkeyup')
		@browser.button( :index => 0).fire_event('onBlur')
		#@browser.form( :index => 0).submit
		
		#		@browser.button( :name => "Submit").click
		sleep(2)
		if not @browser.text.include? "Image Verification is incorrect."
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

