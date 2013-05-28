@browser.goto("https://twitter.com/signup")

retries = 5
begin 
	@browser.text_field(:name => 'user[name]').set data['fullname']
	@browser.text_field(:name => 'user[email]').set data['email']
	@browser.text_field(:name => 'user[user_password]').set data['password']

	while 1
		seed = rand(1000).to_s
		data['username'] = data['username']+seed
		@browser.text_field(:name => 'user[screen_name]').set data['username']
		@browser.text_field(:name => 'user[screen_name]').send_keys :tab
		sleep 2
		@browser.p(:text => 'Validating...').wait_while_present
		sleep 1
		if not @browser.text.include? "This username is already taken!"
			break
		end
	end

	@browser.checkbox(:name => 'user[remember_me_on_signup]').clear
	@browser.checkbox(:name => 'user[use_cookie_personalization]').clear

	@browser.button(:value => 'Create my account').click


sleep 5 

	if @browser.text.include? "Are you human?"
		retry_captcha
		if @browser.text.include? "Join Twitter today."
			raise "Captcha code invalid"
		end
	end

rescue RuntimeError => e # this rescues from the "Raise" statement above. 
	puts e.inspect
	if retries > 0
		retries -= 1
		retry
	else
		throw "Twitter account creation failed, likely due to captcha."
	end

rescue Exception => e
	puts e.inspect
	if retries > 0


		retries -= 1
		retry
	else
		throw "Twitter account creation failed."
	end

end

@browser.goto("https://twitter.com/")

sleep 2
Watir::Wait.until{@browser.text.include? "Here are some people you might enjoy following." }

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['username'], 'account[password]' => data['password'], 'model' => 'Twitter'

if @chained
	self.start("Twitter/Verify")
end

true