
@business_url = nil
def sign_in( data )

	@browser.goto( 'https://foursquare.com/login' )
	@browser.text_field( :id, 'username' ).set data[ 'username' ]
	@browser.text_field( :id, 'password' ).set data[ 'password' ]
	@browser.button( :value, 'Log in' ).click

end



def claim_listing( data )
@browser.goto(@business_url)

@browser.link( :text, 'Claim here').click

@browser.checkbox( :id, 'agree' ).click
@browser.span( :text, 'Get Started').click

sleep(3)
@browser.text_field( :id, 'phoneField').set data[ 'phone' ]
sleep(3)
@browser.span( :text, 'Continue').click

code = @browser.text_field(:id, 'phoneField').value
verified = PhoneVerify.enter_code(data[ 'number' ], code)
@browser.span( :text, 'Continue').click

@browser.checkbox( :id, 'finalVerificationOption' ).click
@browser.link( :text, 'Mail me a verification code!').click

end

def add_listing( data )
@browser.goto('https://foursquare.com/add_venue')

@browser.text_field( :id, 'venueName_field').set data[ 'name' ]
@browser.text_field( :id, 'venueAddress_field').set data[ 'address' ]
@browser.text_field( :id, 'venueCrossStreet_field').set data[ 'crossstreet' ]
@browser.text_field( :id, 'venueCity_field').set data[ 'city' ]
@browser.text_field( :id, 'venueState_field').set data[ 'state' ]
@browser.text_field( :id, 'venueZip_field').set data[ 'zip' ]
@browser.select_list( :id, 'venueCountrycode_field').select data[ 'country' ]
@browser.text_field( :id, 'venueTwitterName_field').set data[ 'twitter' ]
@browser.select_list( :name, 'topLevelCategory').select data[ 'category_first' ]
@browser.select_list( :name, 'secondLevelCategory').select data[ 'category_second' ]
@browser.button( :value, 'Save').click

end

sign_in( data )
search_for_business( data )

if @browser.link( :text, "#{data['name']}").exists?
	@business_url = @browser.link( :text, "#{data['name']}").href
	claim_listing( data )
else
	add_listing( data )
end

