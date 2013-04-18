def sign_in(data)
	@browser.goto("http://ebusinesspages.com/")
	@browser.link(:text => 'Login').when_present.click
	@browser.text_field(:name => 'UserName').set data['username']
	@browser.text_field(:name => 'Password').set data['password']
	@browser.button(:id => 'LoginButton').click
end