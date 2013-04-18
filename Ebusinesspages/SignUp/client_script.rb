@browser.goto('http://ebusinesspages.com/')

@browser.link(:text => 'Register').click

@browser.text_field(:name => 'UserName').set data['username']
@browser.text_field(:name => 'Password').set data['password']
@browser.text_field(:name => 'FirstName').set data['fname']
@browser.text_field(:name => 'LastName').set data['lname']
@browser.text_field(:name => 'Email').set data['email']

@browser.button(:name => 'RegisterButton').click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['username'], 'account[password]' => data['password'], 'model' => 'Ebusinesspage'

Watir::Wait.until { @browser.link(:text => 'Log Out') }
	if @chained
		self.start("Ebusinesspages/AddListing")
	end
	true

