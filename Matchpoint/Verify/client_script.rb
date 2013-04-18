#puts(data['url'])
#@browser.goto(data['url'])

@browser.goto("https://providers.matchpoint.com/sitesEmailConfirmation.htm?id=8DDBE925435648BE203A08F82E144DC6")

@browser.text_field(:name => 'fullName').set data['fullname']
@browser.text_field(:name => 'email', :index =>1).set data['email']
puts(data['password'])

@browser.text_field( :name => 'password', :index => 1).focus
@browser.text_field( :name => 'password', :index => 1).set data['password']
		sleep(2)
		@browser.text_field( :name => 'passwordAgain').focus
		@browser.text_field( :name => 'passwordAgain').set data['password']
enter_captcha2(data)


RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'account[username]' => data['email'], 'model' => 'Matchpoint'


	if @chained
		self.start("Matchpoint/AddListing")
	end

true
