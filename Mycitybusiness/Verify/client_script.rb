@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

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