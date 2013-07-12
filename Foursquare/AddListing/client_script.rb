sign_in(data)
sleep 2
@browser.goto 'https://foursquare.com/add_venue?'

sleep 2
@browser.text_field(:id => 'venueName_field').when_present.set data['business']
@browser.text_field(:id => 'venueAddress_field').set data['address']
@browser.text_field(:id => 'venueCity_field').set data['city']
@browser.text_field(:id => 'venueState_field').set data['state']
@browser.text_field(:id => 'venueZip_field').set data['zip']
@browser.text_field(:id => 'venueTwitterName_field').set data['twitter_page']
puts data['phone']
@browser.text_field(:id => 'venuePhone_field').set data['phone']

@browser.select_list(:name => 'topLevelCategory').select data['category_top']
sleep 2
@browser.select_list(:name => 'secondLevelCategory').when_present.select data['category']

puts "1"

5.times do |i|
	@browser.link(:title => "Zoom in").click
	puts "2"
	sleep 3
end 
puts "3"
sleep 3
@browser.image(:class => 'leaflet-tile leaflet-tile-loaded').click
puts "4"
@browser.button(:value => 'Save').click
puts "5"
sleep 2

Watir::Wait.until {@browser.text.include? "Total Visitors"}

self.save_account("Foursquare", {:foursquare_page => @browser.url})

if @chained
	self.start("Foursquare/Notfy")
end


true
