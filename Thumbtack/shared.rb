def sign_in(data)
	@browser.goto("https://www.thumbtack.com/login")
	@browser.text_field(:id => 'login_email').set data['email']
	@browser.text_field(:id => 'login_password').set data['password']
	@browser.button(:text => 'Login').click
end