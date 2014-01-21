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
	   self.save_account("Getfave", {:status => "Account verified successfully. Creating listing..."})
  	   self.success
    else
	   raise "Error while email verification"
    end
else
    puts "Email not found, re-chaining..."
    if @chained
        self.start("Getfave/Verify", 1440)
    end
end
