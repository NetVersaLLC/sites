# Setup
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

  if @browser.ul(:class => "InboxTableBody").link(:text => /Welcome to iFormative/).exists?
    @browser.ul(:class => "InboxTableBody").link(:text => /Welcome to iFormative/).click 
    @browser.div(:text => /iFormative/).wait_until_present

    href = @browser.div(:id => "mpf0_MsgContainer").text.match(/(http:\/\/www.iformative.com\/confirm\/email\/\S*\/)/)[1]
    @browser.goto href
    @browser.div(:text => /succesfully confirmed/).wait_until_present
    true
  else 
    false
  end 
end 

unless click_email_link(data) 
  if @chained
    self.start("Iformative/Verify", 600)
  end
end 
self.success 

