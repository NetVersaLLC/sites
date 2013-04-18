@browser.goto(data['url'])

if @browser.text.include? "Your membership is now confirmed"
puts("Account verified")
	if @chained
		self.start("Localizedbiz/AddBusiness")
	end

true
end
