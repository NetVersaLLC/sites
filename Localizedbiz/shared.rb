def sign_in(data)

	@browser.goto('http://www.localizedbiz.com/login/login.php')
	@browser.text_field(:id => 'username').set data['username']
	@browser.text_field(:id => 'password').set data['password']
	@browser.button( :name => 'Login').click

end
