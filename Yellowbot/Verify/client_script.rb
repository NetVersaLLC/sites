@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def click_email_link(data)
  @browser.goto("https://mail.live.com/") 
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click

  30.times do 
    break if @browser.ul(:class => "InboxTableBody").link(:text => /\[YellowBot\] Confirm/).exist?
    sleep(1)
  end
  return nil unless @browser.ul(:class => "InboxTableBody").link(:text => /\[YellowBot\] Confirm/).exist?

  @browser.ul(:class => "InboxTableBody").link(:text => /\[YellowBot\] Confirm/).click

  @browser.link(:text => /yellowbot/).wait_until_present
  url = @browser.link(:text => /yellowbot/).href
  @browser.goto(url)
  url
end 

if click_email_link(data)
	@browser.text_field( :name => 'login').wait_until_present

	@browser.text_field( :name => 'login').set data['email']
	@browser.text_field( :name => 'password').set data['password']
	@browser.button( :name => 'subbtn').click

	@browser.p(:text => /email address is now confirmed/).wait_until_present

	if @chained
	  self.start("Yellowbot/CheckListing")
	end
else 
	if @chained
	  self.start("Yellowbot/Verify", 15)
	end
end
self.success
