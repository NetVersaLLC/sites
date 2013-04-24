def sign_in(data)
	@browser.goto("https://www.usyellowpages.com/Admin/Reg.aspx?ReturnURL=/MyAccount/?goto=home&ReturnURL=http%3A%2F%2Fwww.usyellowpages.com%2F")
	@browser.text_field(:name => 'EMail').set data['email']
	@browser.text_field(:name => 'Password').set data['password']
	@browser.button(:value => 'Login').click

end
