
puts(data['url'])

@browser.goto(data['url'])

if @browser.text.include? "Account Confirmed"
	if @chained
		self.start("Ezlocal/AddListing")
	end
	true
end	

#