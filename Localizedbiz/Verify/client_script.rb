@browser.goto(data['url'])

sleep 2
Watir::Wait.until { @browser.text.include? "Your membership is now confirmed" }

puts("Account verified")
if @chained
	self.start("Localizedbiz/AddBusiness")
end

true