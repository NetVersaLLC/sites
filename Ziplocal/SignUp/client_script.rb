def add_business( data )
#adds the business, begins by clicking the "add this number" link
	
	@browser.link( :text, 'add this number' ).click
	30.times{ break if @browser.status == "Done"; sleep 1}	
	#fill out the form with client data
	@browser.text_field( :id, 'listingForm:disp').set data[ 'business' ]
	@browser.text_field( :id, 'listingForm:StrAdr').set data[ 'streetnumber' ]
	@browser.text_field( :id, 'listingForm:city').set data[ 'citystate' ]
	@browser.text_field( :id, 'listingForm:zip').set data[ 'zip' ]
	@browser.text_field( :id, 'listingForm:web').set data[ 'website' ]
	@browser.text_field( :id, 'listingForm:email').set data[ 'business_email' ]
	@browser.text_field( :id, 'listingForm:_id154').set data[ 'first_name' ] + ' ' + data[ 'last_name' ] 
	@browser.text_field( :id, 'listingForm:_id159').set data[ 'email' ]
	@browser.radio( :value, 'O').set

	#Now to add categories. At least 1 category is required.
	@browser.button( :id, 'listingForm:addTest2' ).fire_event("onClick")
	
	#wait until category text field loads
	30.times{ break if @browser.status == "Done"; sleep 1}

	#focus the field so we can get the javascript happy
	@browser.text_field( :id, 'listingForm:newSic1').focus
	@browser.text_field( :id, 'listingForm:newSic1').set data[ 'categoryKeyword' ]
	sleep(2)
	@browser.table( :class, 'dr-sb-int-decor-table rich-sb-int-decor-table').tr(:index, 0).click
	sleep(1)
	@browser.button( :value, 'Add new').flash
	@browser.button( :value, 'Add new').click
	sleep(3)
	@browser.link( :text, 'Save').click

	30.times{ break if @browser.status == "Done"; sleep 1}
	true
end


def main( data )
#this method runs the show
	@browser.goto('http://www.ziplocal.com/olc/lookup.faces')

	#wait for page to load
	30.times{ break if @browser.status == "Done"; sleep 1}
		
	#enter the phone number
	@browser.text_field( :id, 'lookupForm:tel').set data[ 'phone' ]
	@browser.link( :id, 'lookupForm:submit').click
	
	#wait until the next page loads
	30.times{ break if @browser.status == "Done"; sleep 1}
	
	if @browser.text.include? 'Click on the listing you want to update.'
		puts ("Business already added. Business name is as bellow")
		puts @browser.element(:css, "td.col_left_align a").text
	else
		add_business(data)		
	end
	true
end

main( data )