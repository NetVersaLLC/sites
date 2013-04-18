def goto_signup_page fb=false
	puts 'Loading Signup Page for Local.com'
	@browser.goto('http://www.local.com/sitemap.aspx')

	@browser.div(:id => 'logBarJoin').click

	#@browser.frame(:id => 'createNewAccount').wait_until_present
  	sleep(10)

  if fb == true
    @frame.locate
    sleep 5
    @frame.link(:id => 'FBRegister').click

    sleep(5)
    #@browser.frame(:src => /FBRegisterProcess.aspx/i).wait_until_present
    @frame2 = @browser.frame(:src => /FBRegisterProcess.aspx/i)

    @frame2.locate
    @frame2.radio(:name => 'welcome_radio', :value => 'no').set
    @frame2.button(:id => 'continueBttn1').click
  end
end

def process_local_signup(profile)
	puts 'Sign up for new Local.com account'
@frame = @browser.frame(:id => 'createNewAccount')
  @frame.text_field(:id, "defaultPageTemplate_firstName").set profile['first_name']
  @frame.text_field(:id, "defaultPageTemplate_lastName").set profile['last_name']
  @frame.text_field(:id, "defaultPageTemplate_displayName").set profile['display_name']
  @frame.text_field(:id, "defaultPageTemplate_emailAddress").set profile['email']
  @frame.text_field(:id, "defaultPageTemplate_password").set profile['password']
  @frame.text_field(:id, "defaultPageTemplate_password2").set profile['password']

  if profile['recieve_offers'] == true
    @frame.fieldset(:class => 'regCreateAct').checkbox(:class => 'fl').set
  else
    @frame.fieldset(:class => 'regCreateAct').checkbox(:class => 'fl').clear
  end
puts("6")
	@frame.button(:id => 'defaultPageTemplate_signUp').click

  #@browser.wait_until {@browser.div(:id => 'logBarMyAct').exists?}

  #@browser.frame(:id => 'createNewAccount').wait_until_present
sleep(5)
puts("7")
  process_extra_fields_signup(profile)

	puts 'Signup is Completed'
	#log_credentials_to_file(profile['email'], profile['password'])
end

def process_local_fbsignup(profile)
	puts 'Sign up for new Local.com account with Facebook'

  #@browser.wait_until {@browser.window(:title => "Log In | Facebook").exists?}
sleep(5)
  @browser.window(:title => "Log In | Facebook").use do
    begin
      @browser.text_field(:id => "email").set profile['fb_email']
      @browser.text_field(:id => "pass").set profile['fb_password']

      @browser.label(:id => 'loginbutton').button(:index => 0).click

      #@browser.wait_until {@browser.label(:id => "grant_required_clicked").exists?}
      sleep(8)
      @browser.label(:id => "grant_required_clicked").button(:index => 0).click

      #@browser.wait_until {@browser.button(:value => 'Allow').exists?}
      sleep(5)
      @browser.button(:value => 'Allow').click
    rescue
      #do nothing
    end
  end

  #@browser.frame(:src => /FBConnectSuccess.aspx/i).wait_until_present
  sleep(5)
  @frame3 = @browser.frame(:src => /FBConnectSuccess.aspx/i)

  @frame3.locate
  @frame3.text_field(:id, "defaultPageTemplate_firstName").set profile['first_name']
  @frame3.text_field(:id, "defaultPageTemplate_lastName").set profile['last_name']
  @frame3.text_field(:id, "defaultPageTemplate_displayName").set profile['display_name']
  @frame3.text_field(:id, "defaultPageTemplate_emailAddress").set profile['email']
  @frame3.text_field(:id, "defaultPageTemplate_password").set profile['password']
  @frame3.text_field(:id, "defaultPageTemplate_password2").set profile['password']

  if profile['recieve_offers'] == true
    @frame3.fieldset(:class => 'regCreateAct').checkbox(:class => 'fl').set
  else
    @frame3.fieldset(:class => 'regCreateAct').checkbox(:class => 'fl').clear
  end

	@frame3.button(:id => 'defaultPageTemplate_SaveBttn').click

  #@browser.wait_until {@browser.div(:id => 'logBarMyAct').exists?}
  sleep(8)
  #@browser.frame(:id => 'createNewAccount').wait_until_present

  process_extra_fields_signup(profile)

  puts 'Signup is Completed with Facebook'
end

def process_extra_fields_signup(profile)
puts("1")
  if profile['extra_fields'] == true
    #begin
    puts("1.5")
    sleep(8)
      @frame.button(:id => 'ContinueBttn').click
puts("2")
sleep(10)
      #@browser.frame(:src => Local.frame2_link1).wait_until_present
      #@frame = @browser.frame(:id => 'createNewAccount')#
      #@browser.frame(:src => Local.frame2_link1)
    #rescue
      #@browser.div(:id => 'logBarMyAct').click
puts("2.5")
#      @browser.wait_until {@browser.link(:id => 'acctSettingsLink').exists?}
sleep(5)
      #@browser.div(:class => 'acctTabWrap').li(:index => 1).link(:index => 0).click

     #@browser.frame(:src => Local.frame2_link2).wait_until_present
    #@frame = @browser.frame(:src => Local.frame2_link2)
    #end
@frame = @browser.frame(:id => 'createNewAccount')
    #@frame.locate
    puts("2.6")
    @frame.text_field(:id => 'Address').set profile['address']
    @frame.text_field(:id => 'City').set profile['city']
    @frame.select_list(:id => 'State').option(:value => profile['state']).select
    @frame.text_field(:id => 'Zip').set profile['zipcode']
puts("3")
    if profile['gender'] == 'male'
      @frame.radio(:id => 'radioMale').set
    elsif profile['gender'] == 'female'
      @frame.radio(:id => 'radioFemale').set
    else
      @frame.radio(:id => 'radioNo').set
    end
puts("4")
    @frame.text_field(:id => 'birthdayMonth').set profile['dob_m']
    @frame.text_field(:id => 'birthdayDay').set profile['dob_d']
    @frame.text_field(:id => 'birthdayYear').set profile['dob_y']

    @frame.checkbox(:id => 'checkboxBirthYear').clear
    if profile['hide_birthday'] == true
      @frame.checkbox(:id => 'checkboxBirthYear').set
    end
puts("5")
    @frame.text_field(:id => 'mobileArea').set profile['mob_1']
    @frame.text_field(:id => 'mobileFirst').set profile['mob_2']
    @frame.text_field(:id => 'mobileLast').set profile['mob_3']

    @frame.button(:id => 'SaveBtn').click

    sleep 8
    #@browser.wait_until {@frame.button(:id => 'SaveBtn').exists?}
    @frame.button(:class => 'regBlkBtn111').click

    sleep 8
    #@browser.wait_until {@frame.button(:id => 'SaveBtn').exists?}
    @frame.button(:id => 'SaveBtn').click
  else
    @browser.frame(:id => 'createNewAccount').div(:class => 'regContinueOpts').link(:index => 0).click
  end
end

def goto_signin_page
	puts 'Loading Signin Page for Local.com'
	@browser.goto('http://www.local.com/sitemap.aspx')

  @browser.div(:id => 'logBarSignIn').click

	#@browser.frame(:id => 'signIn').wait_until_present
  sleep(5)
  @frame = @browser.frame(:id => 'signIn')
end

def process_local_signin(profile)
	puts 'Signin to your Local.com account'

  @frame.text_field(:id, "Username").set profile['email']
  @frame.text_field(:id, "Password").set profile['password']

	if(profile['remember'] == true)
		@frame.checkbox(:id, "rememberMe").set
	else
		@frame.checkbox(:id, "rememberMe").clear
	end

	@frame.button(:value, "SIGN IN").click

	#@browser.wait_until {@browser.div(:id => 'logBarMyAct').exists?}
sleep(5)
	puts 'Signin is Completed'
end

def goto_recover_page
	puts 'Loading Password Recover Page for Local.com'
	@browser.goto('https://advertise.local.com/resetpassword.aspx')

  @browser.div(:id => 'logBarSignIn').click

	#@browser.frame(:id => 'signIn').wait_until_present
  sleep(5)
  @browser.frame(:id => 'signIn').link(:id => 'forgotPasswordLink').click

  #@browser.frame(:id => 'forgotPassword').wait_until_present
  sleep(5)
  @frame = @browser.frame(:id => 'forgotPassword')
end

def process_local_recover(email)
	puts 'Recover your Local.com account'

  @frame.locate
	@frame.text_field(:id => 'defaultPageTemplate_txtEmail').set email

	@frame.button(:id, "defaultPageTemplate_Reset_btn").click

	#@browser.wait_until {@frame.h2(:class => 'regGreyH2').exists?}
sleep(5)
	puts 'Recover Account is Completed'
end

def goto_advertiser_signin_page
  puts 'Loading Login Page for Advertiser on Local.com'
	@browser.goto('https://advertise.local.com/login.aspx')
end

def process_local_advertiser_signin(profile)
  @browser.text_field(:id, "ctl00_ContentPlaceHolder1_email").set profile['email']
  @browser.text_field(:id, "ctl00_ContentPlaceHolder1_password").set profile['password']

  @browser.button(:id => 'ctl00_ContentPlaceHolder1_button_on').click

  sleep 5
end

def goto_advertiser_recover_page
  puts 'Loading Recover Page for Advertiser on Local.com'
	@browser.goto('https://advertise.local.com/resetpassword.aspx')
end

def process_local_advertiser_recover(email)
  @browser.text_field(:id, "ctl00_ContentPlaceHolder1_email").set email

  @browser.div(:class => 'logWrap').button(:index => 0).click

  sleep 5
end

def close_browser
	if !@browser.nil?
		puts 'Browser Closed'
		@browser.close
	end
end

def log_credentials_to_file(email, password)
	t = Time.new
	filename = 'credentials_' + t.year.to_s + '_' + t.month.to_s + '_' + t.day.to_s + '.log'
	File.open(filename, 'a') do |file|
		file.write("\r\nAT: " + t.to_s + "\r\nEMAIL: " + email + "\r\nPASSWORD: " + password + "\r\n\r\n")
	end
end
