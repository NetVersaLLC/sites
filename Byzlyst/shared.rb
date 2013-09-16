def sign_in( data )
	@browser.goto("http://byzlyst.com/wp-login.php")
	@browser.text_field(:id, "user_login").when_present.set data['username']
	@browser.text_field(:id, "user_pass").set data['password']
	@browser.button(:id, "submit").click
end