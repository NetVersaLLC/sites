# Launch url
@url = 'https://www.getfave.com'
@browser.goto(@url)


#Sign in
@browser.link(:text,'Log In/Join').click
@browser.text_field(:id,'session_email').set data[ 'email' ]
@browser.text_field(:id,'session_password').set data[ 'password' ]
@browser.button(:value,'Log In').click
#~ throw("Login unsuccessful") if @sign_in.exist?

# Check for login error
@login_error = @browser.div(:class,'container error')

#Sign up if user doesn't exist
if @login_error.exist? 
	@browser.link(:text,'create a new one,').click
	@browser.text_field(:id,'user_name').set data[ 'name' ]
	@browser.text_field(:id,'user_email').set data[ 'email' ]
	@browser.text_field(:id,'user_password').set data[ 'password' ]
	@browser.button(:value,'Join Us').click

end

if @browser.text.include? 'Please correct the errors and try again.'
		throw ("There are an error while creating the account")
	end

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Getfav'
	puts ("Signup successful. Verifying email to continue")

	
	if @chained
	  self.start("Getfave/Verify")
end

true
