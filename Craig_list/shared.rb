def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\craigslist_captcha.png"
  obj = @browser.image( :xpath, '/html/body/form/table/tbody/tr[2]/td[2]/div/div/table/tbody/tr/td/center/div/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def convert_gender( gender )
	if gender == "Male"
		"Man"
	elsif gender == "Female"
		"Woman"	
	end
end
