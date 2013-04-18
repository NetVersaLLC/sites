@browser.goto('https://providers.matchpoint.com/register.htm')

@browser.text_field( :name => 'firstName').set data[ 'fname' ]
@browser.text_field( :name => 'lastName').set data[ 'lname' ]

@browser.text_field( :name => 'companyName').set data['business']
sleep(5)
@browser.text_field( :name => 'title').set data['title']

@browser.select_list( :name => 'industryId').select data['category1']
@browser.text_field( :name => 'location').set data['city'] + ", " + data['state_name']
@browser.text_field( :name => 'emailAddress').set data['email']
@browser.text_field( :name => 'confirmedEmailAddress').set data['email']

enter_captcha( data )

if @browser.text.include? "You must confirm your e-mail address to activate your account."
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'account[username]' => data['email'], 'model' => 'Matchpoint'
	if @chained
		self.start("Matchpoint/Verify")
	end
true	
end
