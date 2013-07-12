def sign_in(data)
	@browser.goto("https://foursquare.com/login")
	sleep 2
	@browser.text_field(:id => 'username').when_present.set data['email']
	@browser.text_field(:id => 'password').set data['password']

	@browser.button(:value => 'Log in').click

	sleep 2
	Watir::Wait.until { @browser.text.include? "Find great places on the go." }

end


def search_for_business( data )
	@browser.goto( 'https://foursquare.com/search' )

	@browser.text_field(:id, 'q').set data['name']
	@browser.text_field(:id, "near").set data['city']+', '+data['state']
	@browser.button( :value, "Search").click
	
	

end