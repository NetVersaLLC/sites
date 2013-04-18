@browser.goto(data['url'])

if @browser.text.include? "Your email address has been confirmed"
	if @chained
		self.start("Freebusinessdirectory/CreateListing")
	end
true

end