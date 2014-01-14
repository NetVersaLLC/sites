@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

link = data['link']
if not link.nil?
    @browser.goto(link)
    if @browser.text.include? "Log Out"
	   if @chained
  		    self.start("Getfave/CreateListing")
	   end
  	   self.success
    else
	   self.failure("Log Out text not found")
    end
else
    puts "Email not found, re-chaining..."
    if @chained
        self.start("Getfave/Verify", 1440)
    end
end
