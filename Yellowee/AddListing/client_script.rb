
sign_in( data )

@browser.h2( :text => 'Search for Your Business Listing').wait_until_present

@browser.text_field( :id => 'what' ).set data[ 'business' ]
@browser.text_field( :id => 'where' ).set data[ 'query' ]
@browser.button( :id => 'submit' ).click

sleep(3)
Watir::Wait.until { @browser.text.include? 'No Results: Try searching again, or Add Your Business.' or @browser.text.include? 'Search Results'}

if @browser.text.include? "No Results: Try searching again, or Add Your Business."
	businessFound = false
	@browser.link( :text => /Add Your Business/i).click
else
#Loop through found listings and see if any of them match the name of the business.
# If any matches our found we CLaim it, otherwise we add a new listing.
	businessFound = false

	@browser.div(:class => 'business-results').divs.each do |result|
		if result.h3(:text => /#{data['business']}/i).exists?
			if result.button(:id => 'submit').exists?
				businessFound = true
				result.button(:id => 'submit').click
				break
			end
		end
	end

	if businessFound == false
		@browser.button( :name => 'add_new_listing').click
	end

end


if businessFound == false
#this will add the business. If the business is found this step is skipped. 
@browser.text_field( :id => 'id_name').set data[ 'business' ]
@browser.text_field( :id => 'id_address').set data[ 'address' ]
@browser.text_field( :id => 'id_apartment').set data[ 'address2' ]
@browser.text_field( :id => 'location_autocomplete').set data[ 'query' ]
@browser.text_field( :id => 'id_postal_code').set data[ 'zip' ]
@browser.text_field( :id => 'id_phone').set data[ 'phone' ]
@browser.text_field( :id => 'id_website').set data[ 'website' ]

=begin
if data['cat2'] == nil
  data['cat1'] = data['cat3']
end

if data['cat1'] == nil
  data['cat1'] = data['cat2']
  data['cat2'] = data['cat3']
end



@browser.select_list( :name => 'category1_1').select data['cat1']
sleep(2)
if @browser.select_list( :name => 'category1_2').options.to_a.length > 1
  @browser.select_list( :name => 'category1_2').select data['cat2']
end
sleep(2)
if @browser.select_list( :name => 'category1_3').options.to_a.length > 1
  @browser.select_list( :name => 'category1_3').select data['cat3']
end
=end

@browser.select_list( :name => 'category1_1').select data['cat1']
sleep(4)
@browser.select_list( :name => 'category1_2').select data['cat2']

hours = data[ 'hours' ]
hours.each_with_index do |hour, day|
	theday = hour[0]
	theday = theday[0..2]
	theday = theday.capitalize
	open = hour[1][0]
	close = hour[1][1]
	if open[0] = "0"
		open[0] = ''
	end
	if close[0] = "0"
		close[0] = ''
	end

	@browser.select_list( :id => 'day').select theday
	@browser.select_list( :id => 'start_time').select open
	@browser.select_list( :id => 'end_time').select close
	@browser.link(:id => 'add_hours').click

end


@browser.radio(:id => 'id_claim_this_business_0').click
@browser.button( :value => 'Add Business').click

end



Watir::Wait.until { @browser.text.include? "Verify Business Ownership by Phone" }
sleep(3)
#vVrify by phone. 
@browser.link( :text => 'Call Me Now').click
code = PhoneVerify.ask_for_code
@browser.text_field( :id => 'id_pin').set code
@browser.button( :src => '/site_media//images/yellowee_biz/claim-button.png').click


Watir::Wait.until { @browser.text.include? "Update Business Profile" }

@browser.button( :value => 'Update Business').click

@browser.text_field( :id => 'id_description').when_present.set data[ 'description' ]
@browser.text_field( :id => 'id_year').set data[ 'founded' ]

@browser.button( :value => 'Submit Changes').click

Watir::Wait.until { @browser.text.include? "Add Photos to Your Business Profile (optional)" }
sleep(3)
@browser.link( :text => '[Skip]').click

if @browser.text.include? "Basic Business Information"
	puts("Listing added/claimed successfully")
	true
end



