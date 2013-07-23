@browser.goto( 'http://listings.local.yahoo.com/' )
@browser.link( :text => /New User?/ ).click

#@browser.link(:id => 'signUpBtn').click
sleep 2
@browser.text_field(  :id => 'firstname' ).when_present.set   data[ 'first_name' ]
@browser.text_field(  :id => 'secondname' ).set  data[ 'last_name' ]

retries = 3
begin
  nameFound = false
  subtries = 3
  while subtries > 0
    seed = rand(10).to_s
    @browser.text_field(:id => 'yahooid').set data['username'] + seed
    sleep 2
    @browser.text_field(:id => 'yahooid').send_keys :tab
    @browser.text_field(:id => 'password').focus
  
    sleep(8 - retries)

    if @browser.text.include? "This ID is not available"
      subtries -= 1
      next
    else
      data['username'] = data['username'] + seed + "@yahoo.com"
      data['business_email'] = data['username']
      nameFound = true
    end
    if nameFound == true
      break
    end
    
  end

  sleep 4
  Watir::Wait.until(8) { @browser.span( :id => 'choosenyid' ).text ==  data['business_email']}

rescue Watir::Wait::TimeoutError
  if retries > 0
    puts("Something went wrong while choosing the username. Changing approach and trying again.")
    case retries
    when 3
      data['username'] = data['first_name']+data['last_name']
    when 2
      data['username'] = data['last_name']+data['first_name']
    when 1
      data['username'] = data['last_name']+seed+data['first_name']
    end
    retries -= 1
    retry
  else

  end

end

puts("Made it out of the username generator! with this username: "+data['username'])

@browser.text_field( :id => 'password' ).set data[ 'password' ]
@browser.text_field( :id => 'passwordconfirm' ).set data[ 'password' ]
sleep(5)
until not @browser.text.include? "The passwords you entered do not match. Please try again."
	@browser.text_field( :id => 'password' ).set data[ 'password' ]
	@browser.text_field( :id => 'passwordconfirm' ).set data[ 'password' ]
end
@browser.select_list( :id => 'mm' ).select data[ 'month' ]
@browser.text_field(  :id => 'dd' ).set data[ 'day' ]
@browser.text_field(  :id => 'yyyy' ).set data[ 'year' ]
@browser.text_field(  :id => 'mobileNumber' ).set data[ 'phone' ]
@browser.select_list( :id => 'gender' ).select   data[ 'gender' ]
@browser.select_list( :id => 'country' ).select  data[ 'country' ]
@browser.select_list( :id => 'language' ).select data[ 'language' ]
#@browser.select_list( :id => 'mobileCountryCode' ).select "#{business[ 'country_code' ]}"
@browser.text_field(:id => 'altemail').set data['alt_mail']
@browser.text_field(:id => 'postalcode').set data['zip']

@browser.button(:id => 'IAgreeBtn').click
  
sleep 2
Watir::Wait.until{ @browser.button( :id => 'VerifyCollectBtn' ).exist? }

@browser.select_list( :id, 'secquestion' ).select 'Where did you meet your spouse?'
@browser.text_field( :id, 'secquestionanswer' ).set data[ 'secret_answer_1' ]
@browser.select_list( :id, 'secquestion2' ).select 'Where did you spend your childhood summers?'
@browser.text_field( :id, 'secquestionanswer2' ).set data[ 'secret_answer_2' ]

sleep 5
puts data['business_email']
puts data['password']
retry_captcha(data)
sleep 5

self.save_account("Yahoo", {:email => data['business_email'], :password => data['password'], :secret1 => data['secret_answer_1'], :secret2 => data['secret_answer_2']})
#Watir::Wait.until { @browser.button( :id => 'ContinueBtn' ).exists? }

#@browser.button( :id => 'ContinueBtn' ).click



sleep 10
if @chained
  self.start("Yahoo/CreateListing")
end

true

=begin

def sign_up_personal( business )
  puts 'Business is not found - Sign up for new account'
  @browser.goto( 'http://listings.local.yahoo.com/' )
  @browser.link( :text => 'Sign Up' ).click

  puts 'Sign up for new Yahoo account'
  @browser.link(:id => 'signUpBtn').click
  
  #select steps for new & old ui
  #if @browser.select_list( :id, 'secquestion' ).exist?
  #  old_signup_ui(business)
  #else
    new_signup_ui(business)
  #end
  
  # decode captcha code
  retry_captcha(business)
  
  puts 'Continue to Yahoo Local'

  if @browser.button( :id => 'ContinueBtn' ).exist?
	  puts "Initial registration successful"
  else
	  throw("Initial Registration is not successful")
  end
  
  # .. waits long here
#  def homepage_checkbox; @browser.checkbox( :id => 'setHomepage' ) end
#  if homepage_checkbox.exists? then homepage_checkbox.clear end

#@browser.button( :id => 'ContinueBtn' ).click

  RestClient.post "#{@host}/yahoo/save_email.json?auth_token=#{@key}&business_id=#{@bid}", :email => business['business_email'], :password => business['password'], :secret1 => business['secret_answer_1'], :secret2 => business['secret_answer_2']
end

def new_signup_ui(business)
  @browser.text_field(  :id => 'firstname' ).when_present.set   business[ 'first_name' ]
  @browser.text_field(  :id => 'secondname' ).set  business[ 'last_name' ]
  # select suggested user id
  @browser.text_field( :id => 'yahooid' ).clear # shows suggestions list; [click, flash]
  @browser.execute_script("document.getElementById('yahooid').focus();")

  if not @browser.div(:id=>'yidsuggestion').exist? && @browser.div(:id=>'yidsuggestion').text.include?('Sorry no ID suggestions are available')
    Watir::Wait::until do
      @browser.element(:xpath, '//ol[@id="yidSug"]/li[1]/a').exists?
    end
  end
  @browser.element(:xpath, '//ol[@id="yidSug"]//a[1]').click

  # .. remember the selected email to click in account confirmation email later
  Watir::Wait::until do @browser.span( :id => 'choosenyid' ).exists? end
  business[ 'business_email' ] = @browser.span( :id => 'choosenyid' ).text
  
  @browser.text_field( :id => 'password' ).set business[ 'password' ]
  @browser.text_field( :id => 'passwordconfirm' ).set business[ 'password' ]
  @browser.select_list( :id => 'mm' ).select business[ 'month' ]
  @browser.text_field(  :id => 'dd' ).set business[ 'day' ]
  @browser.text_field(  :id => 'yyyy' ).set business[ 'year' ]
  @browser.text_field(  :id => 'mobileNumber' ).set business[ 'phone' ]
  @browser.select_list( :id => 'gender' ).select   business[ 'gender' ]
  @browser.select_list( :id => 'country' ).select  business[ 'country' ]
  @browser.select_list( :id => 'language' ).select business[ 'language' ]
  #@browser.select_list( :id => 'mobileCountryCode' ).select "#{business[ 'country_code' ]}"
  @browser.text_field(:id => 'altemail').set business['alt_mail']
  @browser.text_field(:id => 'postalcode').set business['zip']

  @browser.button(:id => 'IAgreeBtn').click
  
  if @browser.button( :id => 'VerifyCollectBtn' ).exist?
    puts "Initial registration successful"
  else
    throw("Initial Registration is not successful")
  end
  
  @browser.select_list( :id, 'secquestion' ).select 'Where did you meet your spouse?'
  @browser.text_field( :id, 'secquestionanswer' ).set business[ 'secret_answer_1' ]
  @browser.select_list( :id, 'secquestion2' ).select 'Where did you spend your childhood summers?'
  @browser.text_field( :id, 'secquestionanswer2' ).set business[ 'secret_answer_2' ]
end

def old_signup_ui(business)
  @browser.text_field(  :id => 'firstname' ).set   business[ 'first_name' ]
  @browser.text_field(  :id => 'secondname' ).set  business[ 'last_name' ]
  @browser.select_list( :id => 'gender' ).select   business[ 'gender' ]
  @browser.select_list( :id => 'mm' ).select       business[ 'month' ]
  @browser.text_field(  :id => 'dd' ).set          business[ 'day' ]
  @browser.text_field(  :id => 'yyyy' ).set        business[ 'year' ]
  @browser.select_list( :id => 'country' ).select  business[ 'country' ]
  @browser.select_list( :id => 'language' ).select business[ 'language' ]
  @browser.text_field(  :id => 'postalcode' ).set  business[ 'zip' ]

  # .. select email
  @browser.text_field( :id => 'yahooid' ).clear # shows suggestions list; [click, flash]
  @browser.execute_script("document.getElementById('yahooid').focus();")

  Watir::Wait::until do
    @browser.element(:xpath, '//ol[@id="yidSug"]/li[1]/a').exists?
  end
  @browser.element(:xpath, '//ol[@id="yidSug"]//a[1]').click

  # .. remember the selected email to click in account confirmation email later
  Watir::Wait::until do @browser.span( :id => 'choosenyid' ).exists? end
  business[ 'business_email' ] = @browser.span( :id => 'choosenyid' ).text

  # or browser.ol( :id => 'yidSug' ).li( :index => 0 ).click;
  # browser.find_elements_by_xpath("div[@id='yidsuggestion'/li[0]").click
  @browser.text_field( :id => 'password' ).set business[ 'password' ]
  @browser.text_field( :id => 'passwordconfirm' ).set business[ 'password' ]

  # .. skip alternate email
  @browser.select_list( :id, 'secquestion' ).select 'Where did you meet your spouse?'
  @browser.text_field( :id, 'secquestionanswer' ).set business[ 'secret_answer_1' ]
  @browser.select_list( :id, 'secquestion2' ).select 'Where did you spend your childhood summers?'
  @browser.text_field( :id, 'secquestionanswer2' ).set business[ 'secret_answer_2' ]
end

sign_up_personal(data)

if @chained
  self.start("Yahoo/CheckListing")
end

true
=end