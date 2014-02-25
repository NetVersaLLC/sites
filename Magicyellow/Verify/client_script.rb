@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def get_password_from_email(data)
  @browser.goto("https://mail.live.com/")
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click

  30.times do
    sleep(2)
    break if @browser.ul(:class => "InboxTableBody").link(:text => /MagicYellow.com Business Center Login/).exist?
  end 
  return nil unless @browser.ul(:class => "InboxTableBody").link(:text => /MagicYellow.com Business Center Login/).exist?

  puts 'email found'
  @browser.ul(:class => "InboxTableBody").link(:text => /MagicYellow.com Business Center Login/).click

  @browser.div(:text => /login and password/).text.match(/Password: (\S{6})/)[1]
end 

password = get_password_from_email(data)

if password 
	self.save_account("Magicyellow", {:email => data['email'], :password => password })
	if @chained
	  self.start("Magicyellow/UpdateListing")
	end
else 
	if @chained
	  self.start("Magicyellow/Verify", 60)
	end
end

self.success

