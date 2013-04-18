@browser.goto( 'http://xml.localxml.com/index.php/login' )

@browser.button( :text => 'Sign Up').click

@browser.text_field( :id => 'first_name').set data[ 'firstname' ]
@browser.text_field( :id => 'last_name').set data[ 'lastname' ]
@browser.text_field( :id => 'email').set data[ 'email' ]
@browser.text_field( :id => 'password').set data[ 'password' ]
@browser.text_field( :id => 'confirm_password').set data[ 'password' ]

enter_captcha( data )

if @browser.text.include? "Thank you for registering. An activation email has just been sent to your email address. Use the link in that email to activate your account."
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Yellowise'
	if @chained
		self.start("Yellowise/Verify")
	end
true

end
