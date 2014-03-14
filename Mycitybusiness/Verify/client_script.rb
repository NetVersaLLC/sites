@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}
def click_verification_link(data) 

  click_email =   "var title = /myCity Business Activation Link/; 
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
      if(divs[i].textContent.contains('activate your business')){
        return divs[i].textContent; 
        }
      }
    return false;"

  @browser.goto("https://mail.live.com/") 
  sleep(30)
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click
  sleep(30)

  if @browser.link(:text => 'continue to your inbox').exist? 
    @browser.link(:text => 'continue to your inbox').click
    sleep(30)
  end 

  if !@browser.execute_script(click_email) 
    sleep(5)
    @browser.execute_script(click_junk_folder)
    sleep(10)
    return nil if !@browser.execute_script(click_email) 
  end 
  sleep(30)

  email_body = @browser.execute_script(get_code) 
  href = /listing: (http:\/\/\S+) If/.match(email_body)[1] 

  raise('could not find verification link in the email') unless href

  @browser.goto href
  sleep(30)
  @browser.p(:text => /Thank you for adding/).exist?
end

heap = JSON.parse( data['heap'] )
click_verification_link(data) 
heap['account_verified'] = true 

# my city business does not provide links.
url = URI::encode("http://www.mycitybusiness.net/search.php?kword=#{data['business']}&city=#{data['city']}&state=#{data['state']}")

self.save_account("Mycitybusiness", {:listing_url => url, :heap => heap.to_json} )
self.success



