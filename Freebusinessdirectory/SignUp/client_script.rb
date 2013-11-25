@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

@password = data['password']

def enter_captcha( button, field, image, successTrigger, failureTrigger=nil )
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha(image)
    @browser.text_field(:id => 'pass2').set @password
    @browser.text_field(:id => 'pass1').set @password
    field.set captcha_code
    button.click

    30.times{ break if @browser.status == "Done"; sleep 1}
    
    unless failureTrigger.nil? or @browser.text.include?( failureTrigger)
      capSolved = true
    end
    
  count+=1  
  end
  if capSolved == true
    Watir::Wait.until { @browser.text.include? successTrigger }
    true
  else
    throw("Captcha was not solved")
  end
end

@browser.goto( 'http://freebusinessdirectory.com/signup.php' )

@browser.text_field(:id => 'company_name').set data['business_name']
@browser.text_field(:id => 'firstname').set data['contact_first_name']
@browser.text_field(:id => 'lastname').set data['contact_last_name']
@browser.text_field(:id => 'email').set data['email']
@browser.text_field(:id => 'user_id').set data['userid']
#@browser.text_field(:id => 'pass2').set data['password']
#@browser.text_field(:id => 'pass1').set data['password']
image = @browser.image(:id => 'validn_img')
captcha = @browser.text_field(:id => 'validn_code')
submit = @browser.button(:id => 'newcompany')

 #This one is weird; success returns a long SMTP log
enter_captcha(submit,captcha,image,"SMTP")

self.save_account("Freebusinessdirectory", { :userid => data['userid'], 
  :email => data['email'], :password => data['password']})
  
if @chained
  self.start("Freebusinessdirectory/Verify")
end
true