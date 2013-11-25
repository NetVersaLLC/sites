def signup (data)
  tries ||= 5
  @browser.goto('https://providers.matchpoint.com/register.htm')

  @browser.text_field( :name => 'firstName').set data[ 'fname' ]
  @browser.text_field( :name => 'lastName').set data[ 'lname' ]

  @browser.text_field( :name => 'companyName').set data['business']
  sleep(5)
  @browser.text_field( :name => 'title').set data['title']

  @browser.select_list( :name => 'industryId').select data['category1']
  @browser.text_field( :name => 'location').set data['city'] + ", " + data['state_name']
  @browser.text_field( :name => 'emailAddress').set data['email']
  @browser.text_field( :name => 'confirmedEmailAddress').set data['email']
  @browser.check_box(:id>/termCondition/i).check
  button = @browser.button(:value => /Create My Account/i)
  field = @browser.text_field(:name=>/verifyWord/i)
  image = @browser.image(:src=>/mpJcaptcha/i)
  enter_captcha(button,field,image,"You must confirm your e-mail address to activate your account.") 
end
rescue => e
  if (tries -= 1) > 0
    puts "Matchpoint/SignUp failed. Retrying #{tries} more times."
    puts "Details: #{e.message}"
    sleep 2
    retry
  else
    puts "Matchpoint/SignUp failed. Out of retries. Quitting."
    raise e
  end
else
  puts "Matchpoint/SignUp succeeded!"
  credentials = {
    :username => data['email'],
    :password => data['password']
  }
  self.save_account("Matchpoint", credentials)
  self.start("Matchpoint/Verify") if @chained
  true
end

@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

signup data