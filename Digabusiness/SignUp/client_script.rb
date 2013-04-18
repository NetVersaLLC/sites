@browser.goto("http://www.digabusiness.com/profile.php?mode=register&agreed=true")

@browser.text_field(:name => 'LOGIN').set data['email']
@browser.text_field(:name => 'NAME').set data['fname'] +" "+data['lname']
@browser.text_field(:name => 'PASSWORD').set data['password']
@browser.text_field(:name => 'PASSWORDC').set data['password']
@browser.text_field(:name => 'EMAIL').set data['email']
@browser.checkbox(:name => 'AGREE').click

enter_captcha_signup( data )


Watir::Wait.until { @browser.text.include? "Thank you for registering. Your account has been created." } #effectively an IF
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Digabusiness'
	if @chained
		self.start("Digabusiness/AddListing")
	end
	true
