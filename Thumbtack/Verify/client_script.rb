@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

link = data['link']
if link.nil?
	self.start("Thumbtack/Verify", 1440)
else
	@browser.goto(link)
	if @chained
  		self.start("Thumbtack/CreateListing")
	end
end
    
true

