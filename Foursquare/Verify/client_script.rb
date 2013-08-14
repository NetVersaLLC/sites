@browser.goto(data['url'])

@browser.text_field(:id => 'password').set data['password']
@browser.button(:value => 'Log in').click

sleep 2
#Watir::Wait.until { @browser.text.include? "Send the download link to your phone:" }

30.times{break if @browser.url =~ /foursquare.com\/activity/; sleep 1}

if @chained
	self.start("Foursquare/AddListing")
end

true
