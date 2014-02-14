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

  puts 'polling afaor verification email'
  quit_time = Time.now + 5 * 60;
  until @browser.ul(:class => "InboxTableBody").link(:text => /\[YellowBot\] Confirm/).exists?
    return false if Time.now > quit_time
    folder = (folder == /Junk/ ? /Inbox/ : /Junk/)
    sleep 5
    puts 'switching folder and checking' 
    @browser.ul(:id => "folderListControlUl").link(:title => folder).click 
  end

  puts 'email found'
  @browser.ul(:class => "InboxTableBody").link(:text => /\[YellowBot\] Confirm/).click
  @browser.div(:text => /confirm your email/).link(:text => /yellowbot/).when_present.click

  puts 'clicked link.  waiting for 2nd window'
  Watir::Wait.until do 
    @browser.windows.size > 1 && @browser.windows[1].url.include?("yellowbot")
  end 

  @browser.window(:url => /yellowbot/).use
end 

click_email_link(data)

@browser.text_field( :name => 'login').set data['email']
@browser.text_field( :name => 'password').set data['password']
@browser.button( :name => 'subbtn').click

@browser.p(:text => /email address is now confirmed/).wait_until_present

if @chained
  self.start("Yellowbot/CheckListing")
end

self.success
