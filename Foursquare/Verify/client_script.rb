@browser.goto(data['url'])

@browser.text_field(:id => 'password').set data['password']
@browser.button(:value => 'Log in').click

Watir::Wait.until { @browser.text.include? "Send the download link to your phone:" }

if @chained
	self.start("Foursquare/ClaimListing")
end

true
