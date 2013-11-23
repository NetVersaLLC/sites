@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

@browser.goto(data['url'])

if @browser.text.include? "Your email address has been confirmed"
	if @chained
		self.start("Freebusinessdirectory/CreateListing")
	end
true

end