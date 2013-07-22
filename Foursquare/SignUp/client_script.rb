@browser.goto 'https://foursquare.com/venue/claim'

#@browser.goto(url)


# The current version of Twebst Web Recorder does NOT support recording in frames/iframes.
# You have to manually add browser.frame statements.
# See: http://wiki.openqa.org/display/WTR/Frames 

sleep 2
@browser.text_field(:name => 'query').when_present.set data['business']
@browser.text_field(:name => 'location').set data['citystate']
@browser.button(:id => 'searchButton').click

sleep 2
@browser.link(:text => /here/).click
# @browser.link(:class => 'addVenueLink').click

sleep 2
@browser.text_field(:id => 'inputEmail').set data['email']
@browser.text_field(:id => 'inputPassword').set data['password']
@browser.text_field(:id => 'inputFirstName').set data['first_name']
@browser.text_field(:id => 'inputLastName').set data['last_name']
@browser.text_field(:name => 'birthMonth').set data['birth_month']
@browser.text_field(:id => 'inputBirthDate').set data['birth_day']
@browser.text_field(:name => 'birthYear').set data['birth_year']
@browser.button(:value => 'Sign Up').click

sleep 2
Watir::Wait.until{@browser.text_field(:id => 'venueAddress_field').exists?}

self.save_account("Foursquare", {:email => data['email'],:password => data['password']})
sleep 2
if @chained
	self.start("Foursquare/Verify")
end

true

=begin
@browser.text_field(:id => 'venueAddress_field').when_present.set data['address']

browser.text_field(:id => 'venueZip_field').set data['zip']
browser.text_field(:id => 'venueTwitterName_field').set data['twitter_page']
browser.text_field(:id => 'venuePhone_field').set '4246662891'

browser.select_list(:name => 'topLevelCategory').select 'Outdoors & Recreation'
browser.select_list(:name => 'secondLevelCategory').select 'Island'


5.times do |i|
	@browser.link(:title => "Zoom in").click
	sleep 3
end 

browser.image(:class => 'leaflet-tile leaflet-tile-loaded').click


=begin


browser.checkbox(:id => 'agree').set
browser.span(:class => 'continueButton greenButton biggerButton').click
browser.span(:class => 'continueButton greenButton biggerButton').click
browser.div(:id => 'wrapper').click
browser.text_field(:id => 'phoneField').set '4246662891'
browser.span(:class => 'continueButton greenButton biggerButton').click
browser.span(:class => 'continueButton biggerButton loadingButton disabledButton').click
browser.text_field(:id => 'phoneField').set '4246662891'
browser.span(:class => 'continueButton greenButton biggerButton').click
browser.text_field(:id => 'phoneField').RightClick()
browser.div(:id => 'wrapper').click


#@browser = Watir::browser.start("https://foursquare.com/search?q=saigon&near=columbia%2C+mo")
#@browser.text_field(:id, 'searchBox').set data['name']
#@browser.text_field(:id, "locationInput").set data['city']+', '+data['state']
#@browser.button( :id, 'searchButton').click
#@browser.a(:class, "p.translate > input.greenButton.translate").click
#@browser.a(:text, "Saigon Bistro").click
#@browser.a(:text, "Claim here").click
#@browser.a(:text, "Sign up for foursquare").click
#@browser.a(:text, "Sign up with Email").click
@browser.text_field(:id, "inputFirstName").set data['first_name']
@browser.text_field(:id, "inputLastName").set data['last_name']
#@browser.text_field(:class, "#emailWrapper > span.input-holder > span.input-default").click
@browser.text_field(:id, "inputEmail").set data['email']
@browser.text_field(:id, "inputPassword").set data['password']
@browser.text_field(:id, "userPhone").set data['phone']
@browser.text_field(:id, "userLocation").set data['city']
@browser.select_list(:name, "birthMonth").select data['birth_month']
@browser.select_list(:name, "birthDate").select data['birth_day']
@browser.select_list(:name, "birthYear").select data['birth_year']
#@browser.file_field(:class, "F221050266022QSTXN5").set data.profile_image
@browser.file_field(:type => 'file').set data['logo']
@browser.button(:value, "Join").click

#RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Foursquare'

self.save_account("Foursquare", {:email => data['email'],:password => data['password']})

sleep 2
Watir::Wait.until{@browser.text.include? "Now you can check in!"}

@browser.a(:id, "continueLink").click

sleep 2
Watir::Wait.until{@browser.text.include? "Welcome! Now let's find you some friends."}

@browser.link(:id => 'done').click

	if @chained
		self.start("Foursquare/Verify")
	end

true
=end