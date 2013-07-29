if data['url'].nil? then
	if @chained
		self.start("Mycitybusiness/Verify", 1440)
		true
	end
else
	@browser.goto(data['url'])
	if @browser.text.include? "Thank you for adding your business to mycityBusiness.net."
	  true
	end
end