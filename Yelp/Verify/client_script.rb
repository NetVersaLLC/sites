@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

link = data['link']

@browser.goto(link)

if link.nil?
	self.start("Yelp/Verify", 1440)
    self.success("Could not find e-mail, trying again in 24 hours")
else
	Watir::Wait.until? do
 		@browser.text.include? "Thanks for Submitting your Business to Yelp"
	end
    self.success("Job completed successfully")
end
