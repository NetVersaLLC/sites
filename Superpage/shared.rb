def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\business_captcha.png"
  obj = @browser.image( :xpath, "/html/body/div[2]/div[2]/div/div/form/div/table/tbody/tr[2]/td/div/div[2]/table/tbody/tr[10]/td[2]/div/img" )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def prepare_time(time_string)
time_string.gsub('PM', ' PM')
time_string.gsub('AM', ' AM')
time_string
end


def are_hours_set(business)
@hoursset = false

	if business.monday_enabled
		@hoursset =  true
	elsif business.tuesday_enabled
		@hoursset =  true
	elsif business.wednesday_enabled
		@hoursset =  true
	elsif business.thursday_enabled
		@hoursset =  true
	elsif business.friday_enabled
		@hoursset =  true
	elsif business.saturday_enabled
		@hoursset =  true
	elsif business.sunday_enabled	
		@hoursset =  true
	end

@hoursset
end

def enter_captcha( data )

	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha
		@browser.text_field( :id, 'captchaRes').set captcha_code
		@browser.link( :text, 'continue' ).click
		
		if @browser.div( :class, 'error').exists?
			errors = @browser.div( :class, 'error').text
			puts( errors )
		end

		if not @browser.text.include? "Please try again.  Entry did not match display."
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

