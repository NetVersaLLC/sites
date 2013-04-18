def goto_signup_page
	puts 'Loading Signup Page for Tupalo'
	@browser.goto('http://tupalo.com/en/accounts/sign_up')
end

def process_tupalo_signup(profile)
	puts 'Sign up for new Tupalo account'

	@browser.text_field(:id, "account_email").set profile['email']

	@browser.button(:value, "Join Tupalo's vibrant community").click

	@browser.wait_until {@browser.li(:id, "navUserNavigation").exists?}

	@browser.li(:id, "navUserNavigation").link(:id, "navLink").click

	@browser.wait_until {@browser.ul(:id, "userNavigation").visible?}

	@browser.link(:text, "Settings").click

	@browser.wait_until {@browser.div(:class, "settings").exists?}

	@browser.text_field(:id, "user_first_name").set profile['first_name']
	@browser.text_field(:id, "user_last_name").set profile['first_name']
	@browser.text_field(:id, "user_nick_name").set profile['nickname']
	@browser.text_field(:id, "user_city_and_country").set profile['location']

	begin
    #sleep 4
		@browser.wait_until {@browser.div(:class => "acResults", :index => 2).visible?}
    @browser.div(:class => "acResults", :index => 2).li(:index => 0).click
	rescue StandardError => err
    puts 'Failed to Setup Location => ' + err
	end

	@browser.select_list(:id, "user_language").option(:value, profile['language']).select
	@browser.text_field(:id, "user_account_attributes_email").set profile['email']
	@browser.text_field(:id, "user_website").set profile['website']
	@browser.text_field(:id, "user_website_name").set profile['website_name']
	@browser.text_field(:id, "user_biography").set profile['biography']

	@browser.button(:text, "Save").click

	#@browser.wait_until {@browser.div(:class => 'notice').exists?}
	#@browser.wait_until {@browser.div(:class => 'notice').text.include? 'Settings updated'}

	puts 'Signup is Completed'
	#log_credentials_to_file(profile['email'])
end

def goto_signin_page
	puts 'Loading Signin Page for Tupalo'
	@browser.goto('http://tupalo.com/en/accounts/sign_in')
end

def process_tupalo_signin(profile)
	puts 'Signin to your Tupalo account'
  puts(profile['email'])
  puts(profile['password'])
	@browser.text_field(:id, "account_email").set profile['email']
	@browser.text_field(:id, "account_password").set profile['password']

	if(profile['remember'] == true)
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

def close_browser
	if !@browser.nil?
		puts 'Browser Closed'
		@browser.close
	end
end

def log_credentials_to_file(email)
	t = Time.new
	filename = 'credentials_' + t.year.to_s + '_' + t.month.to_s + '_' + t.day.to_s + '.log'
	File.open(filename, 'a') do |file|
		file.write("\r\nAT: " + t.to_s + "\r\nEMAIL: " + email + "\r\n\r\n")
	end
end
