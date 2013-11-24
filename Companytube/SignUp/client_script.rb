def signup(data)
  tries ||= 5
  @browser.goto 'http://www.companytube.com/join.php'

  @browser.text_field(:name => 'first_name').set data['contact_first_name']
  @browser.text_field(:name => 'last_name').set data['contact_last_name']
  @browser.text_field(:name => 'email_address').set data['email']
  @browser.text_field(:name => 'email_address2').set data['email']
  @browser.select_list(:id => 'dob_month').select data['month']
  @browser.select_list(:id => 'dob_day').select data['day']
  @browser.select_list(:id => 'dob_year').select data['year']
  @browser.text_field(:name => 'zip_code').set data['zip']
  @browser.text_field(:name => 'user_name').set data['username']
  @browser.text_field(:name => 'password').set data['password']
  @browser.text_field(:name => 'confirm_password').set data['password']
  @browser.radio(:name => 'terms').set
  button = @browser.button(:name => 'registe_r')
  field = @browser.text_field(:name => 'captext')
  image = @browser.image(:id=>'verificiation_image')
  enter_captcha(button,field,image,"Registration successful, check your email to complete")
  if @browser.text.include? "Email address has already been used"
    puts "This site already has signed up to Companytube."
  else
    self.save_account("Companytube", { :username=>data['username'],:email => data['email'], :password => data['password']})
  end
rescue
  if (tries -= 1) > 0
    puts "We encountered an error! Retrying #{tries} more times."
    retry
  else
    puts "We've encountered an error, but we're out of retries. Quitting."
  end
else
  puts "Job successful!"
end

@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

#BEGIN CAPTCHA
def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\companytube_captcha.png'].join
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

true
