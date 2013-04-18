def sign_in( data )

	@browser.goto( 'http://www.justclicklocal.com/user/login' )
	@browser.text_field( :id, 'username' ).set data[ 'email' ]
	@browser.text_field( :id, 'password' ).set data[ 'password' ]
	@browser.button( :value, 'submit').click

end
