@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}
def check_email data
  @browser.goto("https://mail.live.com/") 
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click

  if @browser.ul(:class => "InboxTableBody").link(:text => /Activate Your Fave Account/).exist?
    @browser.ul(:class => "InboxTableBody").link(:text => /Activate Your Fave Account/).click
    @browser.link(:text => "go here").wait_until_present
    @browser.link(:text => "go here").href
  else 
    nil
  end
end 


link = check_email(data)
if link.nil?
  puts "Email not found, re-chaining..."
  if @chained
    self.start("Getfave/Verify", 1440)
  end
else
  @browser.goto(link)
  if @browser.link(:text => "Log Out").exist?
    if @chained
      self.start("Getfave/CreateListing")
    end
    self.save_account("Getfave", {:status => "Account verified successfully. Creating listing..."})
    self.success
    else
      raise "Error while email verification"
    end
end

