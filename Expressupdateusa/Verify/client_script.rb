url = data[ 'url' ]
puts("the URL: ")
puts(url)
if url.nil?
	self.start("Expressupdateusa/Verify", 1440)
else
	@browser.goto(url)
	if @browser.text.include? 'Your account has been activated please sign in.'
	puts( 'Account verified' )
	self.start("Expressupdateusa/AddListing")
	true
	end
end
