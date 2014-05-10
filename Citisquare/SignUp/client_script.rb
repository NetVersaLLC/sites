@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end
def click_verification_link(data) 

  click_email = "var title = /notify@mail.citysquares.com/; 
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
    
    get_href = "var href = $('div.readMsgBody p a').attr('href');
    return href;"

  # get_code = "
  #   var divs; 
  #   divs = document.querySelector('.ReadMsgContainer').getElementsByTagName('div');
  #   for(var i=0;i<divs.length;i++) { 
  #     console.log(divs[i].textContent);
  #     if(divs[i].textContent.contains('Confirm my account')){
  #       content = divs[i].textContent.split('below:');
  #       return (content[1].split('   ')[0]);
  #       }
  #     }

  #   return false;"

  @browser.goto("https://mail.live.com/") 
  # sleep(30)
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
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

  # email_body = @browser.execute_script(get_code)  
  # href = /listing: (http:\/\/\S+) If/.match(email_body)[1] 
  # href = '/Confirm my account/'.match(email_body)
   # email_body = email_body.split("below:")
    # email = (email_body[1].split("     "))[0]
   # href = @browser.execute_script(window.prompt=function(){email.attribute('href')})
   href = @browser.execute_script(get_href)
  # email_body = @browser.p(:xpath=>'/html/body/div[2]/div[2]/div/div/div/div/div/div[3]/div/div[2]/div/div[2]/div/div[2]/div[3]/div/p[3]').link
    puts href#email_body.attribute('href')#.attribute_value('href')
  raise('could not find verification link in the email') unless href

  @browser.goto href
  sleep(30)
  @browser.p(:text => /Thank you for adding/).exist?
end
def sign_up(data)
  #@browser.link(:text => 'Sign Up Now').click
  #sleep 2
  #@browser.text_field(:name => 'name').when_present.set data['username']
  # @browser.text_field(:name => 'name').when_present.set data['username']
  @browser.text_field(:name => 'user[email]').set data['email'] 
  sleep 10
  @browser.text_field(:name => 'user[first_name]').set data['first_name'] 
  @browser.text_field(:name => 'user[last_name]').set data['last_name'] 
  # @browser.text_field(:name => 'conf_mail').set data['email'] 
  @browser.text_field(:name => 'user[password]').set data['password'] 
  @browser.text_field(:name => 'user[password_confirmation]').set data['password'] 
  
  # @browser.text_field(:name => 'zip').set data['zip'] 
  @browser.button(:value => 'Sign up').click
  sleep 2
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Citisquare'
  click_verification_link data
end  
  
  
# Main Script start from here
# Launch url
url = 'http://citysquares.com/users/sign_up'
@browser.goto url
# click_verification_link data
sign_up data
true
# 30.times{ break if @browser.status == "Done"; sleep 1}

# @browser.text_field(:name => 'b_standardname').set data['business'] 
# @browser.text_field(:name => 'b_zip').set data['zip'] 
# @browser.button(:value => 'Find My Business').click


# sleep 3
# if matching_result data
#   puts "Claiming existing business listing"
#   claim_business data
# else  
#   puts "Adding New business listing"
#   sleep 2
#   @browser.link(:text => 'add it here!').when_present.click
#   @browser.link(:href => /free/).click

#   sleep 2
#   login data 

#   sleep 2
# 	fill_listing_form data

#   @browser.button(:value => 'Add Business').click
#   sleep 2
#   @confirmation = @browser.div(:id => 'landingWelcome')
#   @confirmation_msg = "Welcome to your business dashboard #{data['first_name']}"
  
# 30.times{ break if @browser.status == "Done"; sleep 1}

#   #Check for successful registration
#   if @confirmation.exist? && @confirmation.text.include?(@confirmation_msg)
#       puts "Business successfully registered"
#       self.start("Citisquare/ClaimListing", 4320)
#   end
# true
