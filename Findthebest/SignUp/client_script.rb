def signup (data)
  tries ||= 5
  @browser.goto("http://www.findthebest.com/")

  sleep 5
  @browser.execute_script("create_account_form();")

  @browser.text_field(:id => 'edit-name').when_present.set data['username']
  @browser.text_field(:id => 'edit-mail').set data['email']
  @browser.text_field(:id => 'edit-pass').set data['password']
  @browser.checkbox(:name => 'agree_tc').click

  button = @browser.button(:id => "edit-submit")
  field = @browser.text_field(:id => "recaptcha_response_field")
  image = @browser.div(:id=>"recaptcha_image").image
  enter_captcha(button,field,image,"Thanks for registering. Check your email to confirm your account.")
rescue => e
  if (tries -= 1) > 0
    puts "Findthebest/SignUp failed. Retrying #{tries} more times."
    puts "Details: #{e.message}"
    sleep 2
    retry
  else
    puts "Findthebest/SignUp failed. Out of retries. Quitting."
    raise e
  end
else
  puts "Findthebest/SignUp succeeded!"
  credentials = {
    :email => data['email'],
    :password => data['password']
  }
  self.save_account("Findthebest", credentials)
  true
end

@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

#BEGIN CAPTCHA
def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def enter_captcha( button, field, image, successTrigger, failureTrigger=nil )
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha(image)
    field.set captcha_code
    button.click
    
    if failureTrigger.nil? or not @browser.text.include? failureTrigger
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
#END CAPTCHA

signup data