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

  puts 'polling afaor verification email'
  quit_time = Time.now + 5 * 60;
  until @browser.ul(:class => "InboxTableBody").link(:text => /MagicYellow.com Business Center Login/).exist?
    return false if Time.now > quit_time
    folder = (folder == /Junk/ ? /Inbox/ : /Junk/)
    sleep 5
    puts 'switching folder and checking'
    @browser.ul(:id => "folderListControlUl").link(:title => folder).click
  end

  puts 'email found'
  @browser.ul(:class => "InboxTableBody").link(:text => /MagicYellow.com Business Center Login/).click

  @browser.div(:text => /login and password/).text.match(/Password: (\S{6})/)[1]
end 

password = get_password_from_email(data)

self.save_account("Magicyellow", {:email => data['email'], :password => password })
if @chained
  self.start("Magicyellow/UpdateListing")
end
self.success

