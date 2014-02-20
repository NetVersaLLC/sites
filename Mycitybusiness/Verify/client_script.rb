@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

def get_url_from_email data
  @browser.goto("https://mail.live.com/") 
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click

  if @browser.ul(:class => "InboxTableBody").link(:text => /myCity Business Activation/).exist?
    @browser.ul(:class => "InboxTableBody").link(:text => /myCity Business Activation/).click
    @browser.div(:text => /activate/).wait_until_present
    @browser.link(:text => /activate/).href
  else 
    nil
  end
end 



url = get_url_from_email(data)
if url.nil?
  if @chained
    self.start("Mycitybusiness/Verify", 1440)
  end
else
  self.save_account("Mycitybusiness", {:listing_url => url} )
  @browser.goto(url)
  @browser.p(:text => /Thank you for adding/).wait_until_present
end
self.success
