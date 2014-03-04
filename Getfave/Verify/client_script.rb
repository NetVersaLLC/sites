@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

# have to use scripts because using @browser.link or @browser.span returns permission errors 
# 2014-03-04 15:47:02: Failure: [remote server] https://a.gfx.ms/Shared_76rpP9xhgs1VwFct9hxN3w2.js:1:in `r': Permission denied to access property '__qosId'
#
@click_fave_email =   "var fave = /Activate Your Fave Account/; 
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

def check_email data
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

  found = @browser.execute_script(@click_fave_email) 
  puts "email found #{found} #{found.class}"
  if found 
     #@browser.link(:text => "go here").href
    href = @browser.execute_script(@get_verify_link) 
  else 
    nil
  end 
end 

#        <script type="jsv#137^"></script>Activate Your Fave Account<script type="jsv/137^"></script>‏      

link = check_email(data)
if link.nil?
  puts "Email not found, re-chaining..."
  if @chained
    self.start("Getfave/Verify", 1440)
  end
else
  @browser.goto(link)
  sleep(30)
  if @browser.link(:text => "Log Out").exist?
    if @chained
      self.start("Getfave/CreateListing")
    end
    self.save_account("Getfave", {:status => "Account verified successfully. Creating listing..."})
    else
      raise "Error while email verification"
    end
end
self.success
