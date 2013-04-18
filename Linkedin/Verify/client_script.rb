#puts( data['url'] )
@browser.goto(data['url'])

@browser.text_field( :id, 'session_key-login').set data['email']
@browser.text_field( :id, 'session_password-login').set data['password']

@browser.button( :id, 'btn-primary').click

true