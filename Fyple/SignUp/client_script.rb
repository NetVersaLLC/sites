@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def sign_up(data)
  @browser.goto("http://www.fyple.com/register/")

  @browser.text_field(:id => "CPL_Register1_TName").set data['name']
  @browser.text_field(:id => "CPL_Register1_TEmail").set data['email']
  @browser.text_field(:id => "CPL_Register1_TEmailConfirm").set data['email']
  @browser.text_field(:id => "CPL_Register1_TPass").set data['password']
  @browser.text_field(:id => "CPL_Register1_TPassConfirm").set data['password']
  @browser.checkbox(:id => "CPL_Register1_CAgree").set

  @browser.button(:id => "ctl00_CPL_Register1_RadButton1_input").click
  Watir::Wait.until{ @browser.text.include?( "Thank you for registering") } 

  return click_email_link
end 

def click_email_link(data)
  @browser.goto("https://mail.live.com/") 
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click

  puts 'polling afaor verification email'
  quit_time = Time.now + 5 * 60;
  until @browser.ul(:class => "InboxTableBody").link(:text => /Fyple account/).exists?
    return false if Time.now > quit_time
    folder = (folder == /Junk/ ? /Inbox/ : /Junk/)
    sleep 5
    puts 'switching folder and checking' 
    @browser.ul(:id => "folderListControlUl").link(:title => folder).click 
  end

  puts 'email found'
  @browser.ul(:class => "InboxTableBody").link(:text => /Fyple account/).click 
  @browser.div(:text => /confirm your registration/).link(:text => /confirm/).when_present.click 

  puts 'clicked link.  waiting for 2nd window'
  Watir::Wait.until do 
    if @browser.div(:id => "notificationContainer").button(:text => "Unblock").exists?
      puts 'clicking unblock'
      @browser.div(:id => "notificationContainer").button(:text => "Unblock").click
    end 

    @browser.windows.size > 1 && @browser.windows[1].url.include?("fyple")
  end 

  @browser.window(:url => /fyple/).use
  @browser.text_field(:id => "CPL_LogIn1_TPassword").set data['password']
  @browser.form(:id => "form1").button.click 
  @browser.link(:text => "Go to my company").click

  @browser.windows[0].use 
  @browser.link(:text => "Delete").click

  true 
end 

signed_up = sign_up(data) 

self.save_account("Fyple", {:email => data['email'], :password => data['password'], :status => "Signed up.  Creating listing..."})
if @chained
  if signed_up 
    self.start("Fyple/CreateListing")
  else # couldnt find verification email
    self.start("Fyple/SignUp") 
  end 
end

if signed_up
  self.success
else 
  self.fail( "Verification email did not arrive.")
end
