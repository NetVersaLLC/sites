@browser.goto(data['url'])
30.times{ break if @browser.status == "Done"; sleep 1}
puts("Account verified")
if @chained
	self.start("Localizedbiz/AddBusiness")
end
true