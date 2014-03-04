@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

@click_email =   "var fave = /MagicYellow.com Business Center Login/; 
  var spans; 
  spans = document.getElementsByClassName('Sb');
  for (var i=0;i<spans.length;i++) { 
    var s; 
    s = spans[i];
    if(fave.exec(s.textContent)){ 
      s.click(); 
      return true; 
    }
  }
  return false;"

@get_verify_link =   "var go_here = /go here/; 
  var spans; 
  spans = document.getElementsByTagName('a');
  for (var i=0;i<spans.length;i++) { 
    var s; 
    s = spans[i];
    if(go_here.exec(s.textContent)){ 
      return s.href; 
    }
  }
  return;"


def get_password_from_email(data)
  @browser.goto("https://mail.live.com/")
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click
  sleep(30)

  if @browser.link(:text => 'continue to your inbox').exist? 
    @browser.link(:text => 'continue to your inbox').click
    sleep(30)
  end 

  found = @browser.execute_script( @click_email )
  if found 
    puts 'email found'
    @browser.div(:text => /login and password/).text.match(/Password: (\S{6})/)[1]
  else 
    nil
  end 
end 

password = get_password_from_email(data)

if password 
	self.save_account("Magicyellow", {:email => data['email'], :password => password })
	if @chained
	  self.start("Magicyellow/UpdateListing")
	end
else 
	if @chained
	  self.start("Magicyellow/Verify", 1440)
	end
end

self.success

