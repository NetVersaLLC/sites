@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}
# link = data['link']
# @browser.goto(link)

# if @chained
#   self.start("Thumbtack/CreateListing")
# end

def click_verification_link(data) 

  click_email = "var title = /Thumbtack/; 
    var spans; 
    spans = document.getElementsByClassName('Fm');
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
      if(divs[i].textContent.contains('link to verify')){
         return divs[i].textContent;
        }
      }

    return false;"

  @browser.goto("https://mail.live.com/") 
  # sleep(30)
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['password']
  @browser.form(:name => "f1").button.click
  # sleep(30)

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
  puts email_body  
  href = email_body.split('address:')[1]
  
  @browser.goto href
  sleep(10)
  # @browser.p(:text => /Thank you for adding/).exist?
end

click_verification_link data


if @chained
  self.start("Thumbtack/CreateListing")
end
    
true
  
  


