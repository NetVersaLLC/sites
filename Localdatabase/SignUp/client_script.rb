goto_signup_page


process_localdatabase_signup(data)
@username_increment = 1

	while @browser.text.include? "That username is already in use or does not meet the administrator's standards."
		data[ 'username' ] = data[ 'username' ] + @username_increment.to_s
		process_localdatabase_signup(data)
		@username_increment += 1
	end

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data[ 'username' ], 'account[password]' => data[ 'password' ], 'model' => 'Localdatabase'

	if @chained
		self.start("Localdatabase/Verify")
	end

true



