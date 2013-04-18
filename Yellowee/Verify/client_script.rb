@browser.goto(data['url'])

if @browser.text.include? "Invalid activation key."

	throw("There was a problem activating the account")
else
	if @chained
		self.start("Yellowee/AddListing")
	end
	true
end
