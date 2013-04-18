def sign_in(data)

	@browser.goto("http://www.shopcity.com/map/mapnav_locations.cfm?")
	@browser.link( :text => /#{data['country']}/).when_present.click
	@browser.link( :text => /#{data['state']}/).when_present.click
	@browser.link( :text => /#{data['cityState']}/).when_present.click	
	@browser.link( :title => 'Login').when_present.click
	@browser.text_field( :name => 'email').when_present.set data['email']
	@browser.text_field( :name => 'pw').set data['password']
	@browser.link( :text => "Sign Me In").click

end