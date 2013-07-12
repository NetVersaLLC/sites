
puts(data['url'])

@browser.goto(data['url'])

if @browser.text.include? "Thank you. Your email address has been validated."
	puts("Validation Success")
end	

if @chained
	self.start("Hotfrog/FinishListing")
end
true
#