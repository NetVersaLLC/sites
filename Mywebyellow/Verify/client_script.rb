@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}
def check_email data
  @browser.goto("https://mail.live.com/") 
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['password']
  @browser.form(:name => "f1").button.click

  @browser.ul(:class => "InboxTableBody").link(:text => /MyWebYellow-Listing Approved/).exist?
end 


def find_listing(data)
  @browser.goto "http://www.mywebyellow.com/"

  @browser.text_field(:id => "ctl00_ContentPlaceHolder01_SearchOptions01_fldSearch").set data['bu_name']
  @browser.text_field(:id => "ctl00_ContentPlaceHolder01_SearchOptions01_fldLocation").set data['zip']
  @browser.button(:id => "ctl00_ContentPlaceHolder01_SearchOptions01_butSearch").click

  links = @browser.links(:class => "Link01")

  return nil if @browser.span(:text => /No results/).exist?
  return nil if links.length == 0 || !links.first.text.include?(data['bu_name'])

  links.first.click
  @browser.url
end 


if check_email(data)
  listing_url = find_listing(data)
  self.save_account("Mywebyellow", {:listing_url => listing_url})
else
  puts "Email not found, re-chaining..."
  if @chained
    self.start("Mywebyellow/Verify", 1440)
  end
end
self.success
