@browser = Watir::Browser.new
at_exit do 
  @browser.close unless @browser.nil?
end

def click_verification_link(data) 

  click_email =   "var title = /Please complete your registration/; 
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

  
    get_href  = "return $('.ecxdescr').text();"
    
   if !@browser.execute_script(click_email) 
    sleep(5)
    @browser.execute_script(click_junk_folder)
    sleep(10)
    return nil if !@browser.execute_script(click_email) 
  end 
  sleep(30)

  email_body = @browser.execute_script(get_href)
  href = ((email_body.split('field:'))[1]).split('Please')[0]
  #  href = '(http:\/\/\S+) If/'.match(email_body)[1] 
  puts href
  raise('could not find verification link in the email') unless href

  @browser.goto href
  # sleep(30)
  # @browser.p(:text => /Thank you for adding/).exist?
end

  def click_email_link(data)
  email_click = "
   
    $('div.containsYSizerBar div.ContentLeft div.leftnav div.contentSearchBox span.SearchBox div.c_search_mc input.c_search_box').focus();
    $('div.containsYSizerBar div.ContentLeft div.leftnav div.contentSearchBox span.SearchBox div.c_search_mc input.c_search_box').val('Free Business Directory');"
  button_click = "$('div.containsYSizerBar div.ContentLeft div.leftnav div.contentSearchBox span.SearchBox div.c_search_mc input.c_search_go').click();"
  # add_id =" $('div.containsYSizerBar div.Conte
  @browser.goto("https://mail.live.com/") 
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click
  
  if @browser.link(:text => 'continue to your inbox').exist? 
    @browser.link(:text => 'continue to your inbox').click
  end 
  sleep 10
  @browser.execute_script(email_click)

   @browser.execute_script(button_click)
     
     # sleep 40
  puts "good"
  click_verification_link(data)

  #@browser.h1(:text => /Folders/).wait_until_present

  #if @browser.li(:text=> /Free Business Directory/).exist?
  #  @browser.li(:text=> /Free Business Directory/).link(:text => /complete your registration/).click

  #  @browser.div(:text => /Free Business Directory/).wait_until_present

  #  href = @browser.div(:id => "mpf0_MsgContainer").link(:text => 'here').href
  #  @browser.goto href
  #  @browser.div(:text => /confirmed/).wait_until_present
  #  true
  #else 
  #  false
  #end 
end 

unless click_email_link(data) 
	if @chained
		self.start("Freebusinessdirectory/CreateListing")
	end
end 
puts "Your email is now verified."
self.success 

