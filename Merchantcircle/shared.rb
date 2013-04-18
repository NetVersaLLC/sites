def sign_in(data)

	@browser.goto("https://www.merchantcircle.com/auth/login?")

	@browser.text_field(:id => 'email').set data['email']
	@browser.text_field(:id => 'password').set data['password']

	@browser.button(:name => 'submit').click

end