sign_in(data)

@browser.goto( "http://www.yellowbot.com/" )
@browser.text_field( :id => 'search-field' ).set data[ 'phone' ]
@browser.button( :value => 'Find my business' ).click #, :type => 'submit'

@browser.link( :text, "#{data[ 'name' ]}").click
@browser.link( :text => 'Claim it now!' ).click

@browser.link( :text, 'Claim my business').click

code = PhoneVerify.ask_for_code(number)
