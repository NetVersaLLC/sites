def verify_account_name_available( data )
	
  #Verify user name is available or not
  @browser.text_field(:id, "GmailAddress").value = data['email']
  @browser.div(:id,'gmail-address-form-element').span(:text,'@gmail.com').click
  @browser.text_field(:id, "GmailAddress").send_keys :tab
  @browser.span(:id, "errormsg_0_GmailAddress").text != ""
  if @browser.span(:id, "errormsg_0_GmailAddress") != ""
    puts 'Business Name is already used as a google username.  Need alternate!'
    if data.has_key?('acceptable_alternates')
      data['acceptable_alternates'].each do |new_name|
      @browser.text_field(:id, "GmailAddress").value = new_name
      @browser.text_field(:id, "GmailAddress").send_keys :tab
      if not @browser.span(:id, "errormsg_0_GmailAddress").exists?
        break
      end
      end
    else
      fail StandarError.new('Business Name is already used as a google username.  Need alternate!')
    end
  end
end

def signup_generic( data )

  site = 'https://accounts.google.com/SignUp'
	
  #Launch Browser
  @browser.goto site

  @browser.text_field(:id, "FirstName").value = data['first_name']
  @browser.text_field(:id, "LastName").value = data['last_name']
	
  #Verify if username is available
  verify_account_name_available( data )
	
  @browser.text_field(:id, "Passwd").value = data['pass']
  @browser.text_field(:id, "PasswdAgain").value = data['pass']

  # Number of times to select month
  @browser.div(:class => "goog-inline-block goog-flat-menu-button-dropdown", :index => 0).click
  @browser.div(:text, "#{data['birthmonth']}").click
  @browser.text_field(:id, "BirthDay").value = data['birthday']
  @browser.text_field(:id, "BirthYear").value = data['birthyear']

  # Gender
  @browser.div(:class => "goog-inline-block goog-flat-menu-button-dropdown", :index => 1).click
  @browser.div(:text, "#{data['gender']}").click
  # Country code for US
  country_code = '+1'
  phone = country_code + data['phone']
  @browser.text_field(:id, "RecoveryPhoneNumber").set phone
  @browser.text_field(:id, "RecoveryEmailAddress").value = data['alt_email']
	
  @browser.div(:class => "goog-inline-block goog-flat-menu-button-dropdown", :index => 2).click
  @browser.div(:text, "#{data['country']}").click
  @browser.checkbox(:id,'TermsOfService').set
	
  #get value of email id
  email = @browser.text_field(:id, "GmailAddress").value
  
  #Solve captcha & if there is any captcha mismatch then solve it again
  retry_captcha(data)
  
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => "#{email}@gmail.com", 'account[password]' => data['pass'], 'model' => 'Google'

  if @browser.text_field(:id, 'signupidvinput').exist?
    @browser.text_field(:id, 'signupidvinput').when_present.set data[ 'phone' ]
    @browser.radio(:id,'signupidvmethod-voice').set
    @browser.button(:value,'Continue').click
    # fetch Phone verification code
    @code = PhoneVerify.ask_for_code
    if @browser.span(:class,'errormsg').exist?
      puts "#{@browser.span(:class,'errormsg').text}"
    end
    if @browser.text_field(:id,'verify-phone-input').exist?
      @browser.text_field(:id,'verify-phone-input').when_present.set @code
      @browser.button(:value,'Continue').click
        if @browser.span(:class,'errormsg').exist?
        puts "#{@browser.span(:class,'errormsg').text}"
        end
    end
    if @browser.text.include?("Welcome!")
       puts "Initial Registration is successful"
    else
       puts "Initial Registration is not successful"
    end
  else
    throw("Initial Registration is not successful")
  end
end

login (data)

if @chained
  self.start("Google/CheckListing")
end
true