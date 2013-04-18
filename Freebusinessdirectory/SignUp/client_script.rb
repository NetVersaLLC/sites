@browser.goto( 'http://freebusinessdirectory.com/signup.php' )

@browser.text_field( :name => 'company_name' ).set data[ 'business' ]
@browser.text_field( :name => 'firstname' ).set data[ 'firstname' ]
@browser.text_field( :name => 'lastname' ).set data[ 'lastname' ]
@browser.text_field( :name => 'email' ).set data[ 'email' ]
@browser.text_field( :name => 'user_id' ).set data[ 'userid' ]

enter_captcha( data )


	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['userid'], 'account[password]' => data['password'], 'model' => 'Freebusinessdirectory'
	if @chained
		self.start("Freebusinessdirectory/Verify")
	end
true


