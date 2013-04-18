@browser.goto( 'http://www.hyplo.com/account/signup.php' )

@browser.text_field( :id => 'email').set data[ 'email' ]
@browser.text_field( :id => 'fn').set data[ 'fname' ]
@browser.text_field( :id => 'ln').set data[ 'lname' ]
@browser.text_field( :id => 'pw1').set data[ 'password' ]
@browser.text_field( :id => 'pw2').set data[ 'password' ]
@browser.checkbox( :id => 'nl').click

@browser.button( :value => 'Sign Up').click


Watir::Wait.until { @browser.text.include? "Confirmation sent!" }
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Hyplo'
	if @chained
		self.start("Hyplo/Verify")
	end
true


		    
