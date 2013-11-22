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
