def sign_in( data )

@browser.goto( 'http://www.ibegin.com/account/login/' )
@browser.text_field( :name, 'name' ).set data['email']
@browser.text_field( :name, 'pw' ).set data['password']

@browser.button( :value, /Login/i).click

end
