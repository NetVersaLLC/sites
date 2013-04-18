def sign_in(data)
	@browser.goto("https://foursquare.com/login?continue=%2F&clicked=true")
	@browser.text_field(:id => 'username').set data['email']
	@browser.text_field(:id => 'password').set data['password']

	@browser.button(:value => 'Log in').click

end


def search_for_business( data )
	@browser.goto( 'https://foursquare.com/search' )

	@browser.text_field(:id, 'q').set data['name']
	@browser.text_field(:id, "near").set data['city']+', '+data['state']
	@browser.button( :value, "Search").click
	
	

end