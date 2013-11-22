if :POPAuthenticationError == data['link']
	self.start("Yelp/Verify",1440)
	raise StandardError.new "Could not log into email address. Retrying in one day."
elsif data['link'].nil?
	self.start("Yelp/Verify",1440)
	raise StandardError.new "Failed to find confirmation email from Yelp. Retrying in one day."
end

@browser = Watir::Browser.new :firefox

at_exit do
	unless @browser.nil?
		@browser.close
	end
end

link = data['link']

@browser.goto(link)

Watir::Wait::until do
  @browser.text.include? "Thanks for Submitting your Business to Yelp"
end

true
