# Setup
@browser = Watir::Browser.new
at_exit do 
  @browser.close unless @browser.nil?
end


@click_email =   "var fave = /Welcome to iFormative/; 
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

def click_email_link(data)
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

  if @browser.execute_script( @click_email )
    sleep(30)
    @browser.h1(:text => /Folders/).wait_until_present

    href = @browser.div(:id => "mpf0_MsgContainer").text.match(/(http:\/\/www.iformative.com\/confirm\/email\/\S*\/)/)[1]
    @browser.goto href

    sleep(30)
    @browser.div(:text => /succesfully confirmed/).wait_until_present
    true
  else 
    false
  end 
end 

unless click_email_link(data) 
  if @chained
    self.start("Iformative/Verify", 600)
  end
end 
self.success 

