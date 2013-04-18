def add_business( data )
#adds the business, begins by clicking the "add this number" link
	
	@browser.link( :text, 'add this number' ).click
	Watir::Wait::until do @browser.text_field( :id, 'listingForm:disp').exists? end

	#fill out the form with client data
	@browser.text_field( :id, 'listingForm:disp').set data[ 'business' ]
	@browser.text_field( :id, 'listingForm:StrAdr').set data[ 'streetnumber' ]
	@browser.text_field( :id, 'listingForm:city').set data[ 'citystate' ]
	@browser.text_field( :id, 'listingForm:zip').set data[ 'zip' ]
	@browser.text_field( :id, 'listingForm:web').set data[ 'website' ]
	@browser.text_field( :id, 'listingForm:email').set data[ 'business_email' ]
	@browser.text_field( :xpath, '/html/body[2]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/div[3]/div/div/table/tbody/tr/td[2]/input').set data[ 'first_name' ] + ' ' + data[ 'last_name' ] 
	@browser.text_field( :xpath, '/html/body[2]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/div[3]/div/div/table/tbody/tr[2]/td[2]/input').set data[ 'email' ]
	@browser.radio( :value, 'O').set

	#Now to add categories. At least 1 category is required.
	@browser.button( :id, 'listingForm:addTest2' ).fire_event("onClick")
	
	#wait until category text field loads
	Watir::Wait::until do @browser.text_field( :id, 'listingForm:newSic1').exists? end
	
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
	
	if @browser.text.include? 'Thank you for updating our directory. Updates take effect within 3 business days.'
		puts('Business added successfully')
	end


	true


end


def main( data )
#this method runs the show
	@browser.goto('http://www.ziplocal.com/olc/lookup.faces')

	#wait for page to load
	Watir::Wait::until do @browser.text.include? 'Enter 10 digit phone number' end
	
	#enter the phone number
	@browser.text_field( :id, 'lookupForm:tel').set data[ 'phone' ]
	@browser.link( :id, 'lookupForm:submit').click
	
	#@browser.goto('')

	#wait until the next page loads
	Watir::Wait::until do @browser.text.include? 'We did not find the listings for phone number' or
		@browser.text.include? 'We found the following listing(s) for phone number' end	


		add_business( data )
true
end

main( data )
