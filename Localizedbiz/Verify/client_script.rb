@browser.goto(data['url'])

30.times{break if (begin @browser.text.include?("Your membership is now confirmed") rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1}

puts("Account verified")
if @chained
	self.start("Localizedbiz/AddBusiness")
end

true