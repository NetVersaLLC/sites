def goto_signup_page
  puts 'Loading Signup Page for Tupalo'
  @browser.goto('http://tupalo.com/en/accounts/sign_up')
end

def process_tupalo_signup(data)
  puts 'Sign up for new Tupalo account'
  @browser.text_field(:id, "account_email").set data['email']

  @browser.button(:value, "Join Tupalo").click
	sleep 3
	@browser.goto("http://tupalo.com/en/user/settings/data")
  sleep 2

  @browser.wait_until {@browser.div(:class, "settings").exists?}

  @browser.text_field(:id, "user_first_name").set data['first_name']
  @browser.text_field(:id, "user_last_name").set data['first_name']
  @browser.text_field(:id, "user_nick_name").set data['nickname']
  @browser.text_field(:id, "user_city_and_country").set data['location']

  begin
    #sleep 4
    @browser.wait_until {@browser.div(:class => "acResults", :index => 2).visible?}
    @browser.div(:class => "acResults", :index => 2).li(:index => 0).click
  rescue StandardError => err
    puts 'Failed to Setup Location => ' + err
  end

  @browser.select_list(:id, "user_language").option(:value, data['language']).select
  @browser.text_field(:id, "user_account_attributes_email").set data['email']
  @browser.text_field(:id, "user_website").set data['website']
  @browser.text_field(:id, "user_website_name").set data['website_name']
  @browser.text_field(:id, "user_biography").set data['biography']

  @browser.button(:text, "Save").click

  #@browser.wait_until {@browser.div(:class => 'notice').exists?}
  #@browser.wait_until {@browser.div(:class => 'notice').text.include? 'Settings updated'}

  puts 'Signup is Completed'
end

def goto_signin_page
  puts 'Loading Signin Page for Tupalo'
  @browser.goto('http://tupalo.com/en/accounts/sign_in')
end

def process_tupalo_signin(data)
  puts 'Signin to your Tupalo account'
  puts(data['email'])
  puts(data['password'])
  @browser.text_field(:id, "account_email").set data['email']
  @browser.text_field(:id, "account_password").set data['password']

  if(data['remember'] == true)
    @browser.checkbox(:id, "account_remember_me").set
  else
    @browser.checkbox(:id, "account_remember_me").clear
  end

  @browser.button(:value,"Sign in").click
  @browser.wait_until {@browser.li(:id, "navUserNavigation").exists?}

  puts 'Signin is Completed'
end

def goto_recover_page
  puts 'Loading Password Recover Page for Tupalo'
  @browser.goto('http://tupalo.com/en/accounts/password/new')
end

def process_tupalo_recover(email)
  puts 'Recover your Tupalo account'
  @browser.text_field(:id => 'account_email').set email
  @browser.button(:value, "Send me reset instructions").click
  @browser.wait_until {@browser.div(:class => 'notice').exists?}
  #@browser.wait_until {@browser.div(:class => 'notice').text.include? 'You will receive an email with instructions about how to reset your password in a few minutes.'}

  puts 'Recover Account is Completed'
end

def log_credentials_to_file(email)
  t = Time.new
  filename = 'credentials_' + t.year.to_s + '_' + t.month.to_s + '_' + t.day.to_s + '.log'
  File.open(filename, 'a') do |file|
    file.write("\r\nAT: " + t.to_s + "\r\nEMAIL: " + email + "\r\n\r\n")
  end
end

def fill_listing_form(data)
  @browser.text_field(:id => 'spot_name').set data['business']
  @browser.text_field(:id => 'spot_street').set data['address']
  sleep 2

  @browser.text_field(:id => 'spot_city_and_country').clear
  @browser.text_field(:id => 'spot_city_and_country').send_keys data['city']
 
  @browser.li(:text => /#{data['citystatecountry']}/).when_present.click

  @browser.text_field(:id => 'spot_website').set data['website']
  @browser.text_field(:id => 'spot_phone').set data['phone']

  @browser.select_list(:xpath => '//*[@id="spot_category_input"]/select[1]').select data['category1']
  sleep 3
  if @browser.select_list(:id => 'sublevel_category').exists?
    @browser.select_list(:id => 'sublevel_category').select data['category2']
  end
	
  @browser.button(:name => 'commit').click
end