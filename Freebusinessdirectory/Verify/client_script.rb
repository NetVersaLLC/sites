@browser = Watir::Browser.new
at_exit do 
  @browser.close unless @browser.nil?
end


def click_email_link(data)
  @browser.goto("https://mail.live.com/") 
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click

  @browser.h1(:text => /Folders/).wait_until_present

  if @browser.li(:text=> /Free Business Directory/).exist?
    @browser.li(:text=> /Free Business Directory/).link(:text => /complete your registration/).click

    @browser.div(:text => /Free Business Directory/).wait_until_present

    href = @browser.div(:id => "mpf0_MsgContainer").link(:text => 'here').href
    @browser.goto href
    @browser.div(:text => /confirmed/).wait_until_present
    true
  else 
    false
  end 
end 

unless click_email_link(data) 
	if @chained
		self.start("Freebusinessdirectory/CreateListing")
	end
end 
self.success 

