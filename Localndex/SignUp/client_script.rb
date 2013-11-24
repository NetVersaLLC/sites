def signup(data)
  tries ||= 5
  @browser.goto( 'http://www.localndex.com/register.aspx' )
  @browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserName').when_present.set data ['username']
  @browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserEmail').set data ['email']
  @browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserPass1').set data ['password']
  @browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserPass2').set data ['password']
  button = @browser.input(:id=>"ctl00_MainContentPlaceHolder_btnRegister")
  field = @browser.text_field(:id=>"ctl00_MainContentPlaceHolder_txtSecurity")
  image = @browser.image(:src => /frmCaptchaImg/)
  enter_captcha(button,field,image,"Thank You For Registering!")
rescue => e
  if (tries -= 1) > 0
    puts "Error caught in initial registration: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    retry
  else
    puts "Error in initial registration could not be resolved. Error: #{e.inspect}"
    false
  end
else
  puts "Job Localindex/Signup successful!"
  self.save_account("Localndex", { :email=>data['email'],:username => data['username'], :password => data['password']})
  self.start("Localndex/Verify") if @chained
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

signup(data)