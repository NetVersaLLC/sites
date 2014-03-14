@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
	  @browser.close
	end
}
def sign_in(data)
  signin_url=    'https://login.yahoo.com'
  @browser.goto signin_url
  sleep(30)
  @browser.text_field(:id=> 'username').set data['email']
  @browser.text_field(:id=> 'passwd').set data['password']
  @browser.button(:id=> '.save').click
  sleep(30)
  true
end

def get_verification_code(data) 

  click_yahoo_email =   "var title = /Yahoo! email verification code/; 
    var spans; 
    spans = document.getElementsByClassName('Sb');
    for (var i=0;i<spans.length;i++) { 
      var s; 
      s = spans[i];
      if(title.exec(s.textContent)){ 
        s.click(); 
        return true; 
      }
    }
    return false;"

  click_junk_folder = "
    var folder_name = /Junk/;
    var spans; 
    spans = document.getElementsByClassName('FolderLabel');
    for (var i=0;i<spans.length;i++) { 
      var s; 
      s = spans[i];
      if(folder_name.exec(s.textContent)){ 
        s.click(); 
        return true; 
      }
    }
    return false;"

  get_code = "
    var divs; 
    divs = document.querySelector('.ReadMsgContainer').getElementsByTagName('div');
    for(var i=0;i<divs.length;i++) { 
      console.log(divs[i].textContent);
      if(divs[i].textContent.contains('verification code')){
        return divs[i].textContent; 
        }
      }
    return false;"

  @browser.goto("https://mail.live.com/") 
  sleep(30)
  @browser.text_field(:name => "login").set data['bing_email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click
  sleep(30)

  if @browser.link(:text => 'continue to your inbox').exist? 
    @browser.link(:text => 'continue to your inbox').click
    sleep(30)
  end 

  if !@browser.execute_script(click_yahoo_email) 
    sleep(5)
    @browser.execute_script(click_junk_folder)
    sleep(10)
    return nil if !@browser.execute_script(click_yahoo_email) 
  end 
  sleep(30)

  email_body = @browser.execute_script(get_code) 

  code = /verification code is (\w+)./.match(email_body)[1]
  href = /login to (http:\/\/\S+) and/.match(email_body)[1]
  puts code
  puts href

  raise('could not find verification code in the email') unless code

  @browser.goto href
  sleep(30)
  @browser.link(:text => "Verify").click
  sleep(30)
  @browser.text_field(:id => "txtCaptcha").send_keys code 
  sleep(3)
  @browser.button(:value => "Verify Code").click
  sleep(30)
end

def send_verify_email(data) 
  # When the browser goes through edit -> submit information, this, for some reason, 
  # makes the email verification more reliable on the Yahoo side.
  @browser.goto "http://smallbusiness.yahoo.com/dashboard" 
  sleep(30)
  @browser.link(:text => "Edit").click
  sleep(30)
  @browser.checkbox(:name => "tos").set 
  sleep(5) 
  @browser.button(:text => "Submit information").click 
  sleep(30)
  @browser.radio(:id => "opt-email").set
  sleep(5) 
  @browser.button(:id => "btn-email").click
  sleep(30)
end 

def set_verification_code(data, code)
  @browser.goto "http://smallbusiness.yahoo.com/dashboard" 
  sleep(30)
  @browser.link(:text => "Verify").click
  sleep(30)
  @browser.text_field(:id => "txtCaptcha").send_keys code 
  sleep(3)
  @browser.button(:value => "Verify Code").click
  sleep(30)
end 

def verify_account(data) 
  sign_in(data)
  send_verify_email(data)
  code = get_verification_code(data)
  set_verification_code(data, code)
  true
end 

@heap = JSON.parse( data['heap'] ) 
msg = ""
if !@heap['account_verified']
  @heap['account_verified'] = verify_account(data)
end 


if @heap['account_verified']
  msg = "Account created.  Should receive a post card with verification code in one week."
  self.start("Yahoo/UpdateListing", 1440)
else 
  self.start("Yahoo/Verify", 120)
end
self.save_account("Yahoo", {"heap" => @heap.to_json, "status_message" => msg})

true
