def sign_in( data )
@browser.goto('http://www.hyplo.com/account/login.php')
@browser.text_field( :id => 'email').set data['email']
@browser.text_field( :id => 'pw').set data['password']
@browser.button( :value => 'Log in').click
end
