if data['url'].nil? then
	if @chained
		self.start("Yellowee/Verify", 1440)
	end
	true
else
	@browser.goto(data['url'])

	if @browser.text.include? "Invalid activation key."
		throw("There was a problem activating the account")
	else
		if @chained
			self.start("Yellowee/Notify")
		end
		true
	end
end