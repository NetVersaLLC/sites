@browser.goto( 'http://www.showmelocal.com/businessregistration.aspx' )
@browser.text_field( :id => '_ctl0_txtFirstName').set data[ 'fname' ]
@browser.text_field( :id => '_ctl0_txtLastName').set data[ 'lname' ]
@browser.text_field( :id => '_ctl0_txtEmail').set data[ 'email' ]
@browser.text_field( :id => '_ctl0_txtPassword').set data[ 'password' ]
	enter_captcha( data )
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Showmelocal'
	if @chained
		self.start("Showmelocal/Verify")
	end
true
