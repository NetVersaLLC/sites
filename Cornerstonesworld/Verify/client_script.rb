@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

link = data[ 'url' ]

if link.nil?
	self.start("Cornerstonesworld/Verify", 1440)
else
	@browser.goto(link)

	puts("waiting for email to arrive")
	sleep(15)

	if @chained
		self.start("Cornerstonesworld/GetUsername")
	end

true
