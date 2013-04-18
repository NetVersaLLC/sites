url = data[ 'url' ]
@browser.goto( url )

@browser.button( :name, 'go' ).click
@browser.text_field( :xpath, '/html/body/blockquote/form/fieldset/input').set data[ 'prefix' ]
@browser.text_field( :xpath, '/html/body/blockquote/form/fieldset/input[2]').set data[ 'suffix' ]
@browser.text_field( :xpath, '/html/body/blockquote/form/fieldset/input[3]').set data[ 'last4' ]
@browser.button( :text, 'send the code!' ).click
code = PhoneVerify.ask_for_code(number)

@browser.text_field( :xpath, '/html/body/blockquote/form/input[3]').set code


