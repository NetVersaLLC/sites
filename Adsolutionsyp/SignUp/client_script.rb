def signup(data)
  tries ||= 5
  @browser.goto("https://adsolutions.yp.com/listings/basic")

  @browser.text_field(:id => 'BusinessPhoneNumber').set data['phone']
  @browser.text_field(:id => 'BusinessName').set data['business']
  @browser.text_field(:id => 'BusinessOwnerFirstName').set data['fname']
  @browser.text_field(:id => 'BusinessOwnerLastName').set data['lname']
  @browser.text_field(:id => 'Email').set data['email']
  @browser.text_field(:id => 'txtCategories').set data['category']
  @browser.link(:xpath => "/html/body/ul/li[1]/a").when_present.click
  @browser.text_field(:id => 'BusinessAddress_Address1').set data['address']
  @browser.text_field(:id => 'BusinessAddress_City').set data['city']
  @browser.select_list(:id => 'BusinessAddress_State').select data['state']
  @browser.text_field(:id => 'BusinessAddress_Zipcode').set data['zip']
  @browser.text_field(:id => 'BusinessYear').set data['founded']
  @browser.image(:alt => 'continue').click

  sleep 10
  if @browser.text.include? "matching listing(s) for your business."
    err = "Business has already signed up to Adsolutionsyp! Quitting."
    throw err
  end

  #Watir::Wait::TimeoutError
  @browser.text_field(:id => /BusinessWebsites/i).when_present.set data['website']
  data['payments'].each do |pay|
  	@browser.checkbox(:id => pay).clear
  	@browser.checkbox(:id => pay).click
  end

  button = @browser.div(:class=>'buttonContainer30').button
  field = @browser.input(:id=>'captcha')
  image = @browser.image(:src => /captcha/)
  enter_captcha(button,field,image,"Sign Up for Online Account Services")

  @browser.text_field(:id => 'RepeatEmail').when_present.set data['email']
  @browser.text_field(:id => 'Password').set data['password']
  @browser.text_field(:id => 'RepeatPassword').set data['password']
  @browser.select_list(:id => 'SecurityQuestion').select "What is your mother's maiden name?"
  @browser.text_field(:id => 'SecurityAnswer').set data['secret_answer']
  @browser.checkbox(:id => 'TermsOfUse').click
  @browser.button(:id => 'submitButton').click

  verification = "Your listing will not be displayed on YP.com until you have completed verification."
  Watir::Wait.until {@browser.text.include? verification}
rescue => e
  if (tries -= 1) > 0
    puts "Failed to complete Adsolutionsyp/SignUp. Retrying #{tries} more times."
    puts "Details: #{e.message}"
  else
    puts "Failed to complete Adsolutionsyp/Signup; out of retries. Quitting."
    puts "Details: #{e.message}"
    false
  end
else
  puts "Job Adsolutionsyp/Signup success!"
  save_data = {
    :email => data['email'],
    :password => data['password'],
    :secret_answer => data['secret_answer']
  }
  self.save_account("Adsolutionsyp", save_data)
  self.start("Adsolutionsyp/Notify") if @chained
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