@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

link = data['link']

if link.nil?
	self.start("Merchantcircle/Verify", 1440)
else
	@browser.goto(link)
end

true
