@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def add_business( data )
#adds the business, begins by clicking the "add this number" link

	@browser.link( :text, 'add this number' ).click
	#fill out the form with client data
	@browser.text_field( :id, 'listingForm:disp').when_present.set data[ 'business' ]
	@browser.text_field( :id, 'listingForm:StrAdr').set data[ 'streetnumber' ]
	@browser.text_field( :id, 'listingForm:city').set data[ 'citystate' ]
	@browser.text_field( :id, 'listingForm:zip').set data[ 'zip' ]
	@browser.text_field( :id, 'listingForm:web').set data[ 'website' ]
	@browser.text_field( :id, 'listingForm:email').set data[ 'business_email' ]
	@browser.text_field( :id, 'listingForm:_id154').set data[ 'first_name' ] + ' ' + data[ 'last_name' ] 
	@browser.text_field( :id, 'listingForm:_id159').set data[ 'email' ]
	@browser.radio( :value, 'O').set
	@browser.text_field(:id, "listingForm:_id157").set data['prefix'] #Good to add the prefix lately.

	#Now to add categories. At least 1 category is required.
	@browser.button( :id, 'listingForm:addTest2' ).fire_event("onClick")

	#wait until category text field loads
	Watir::Wait.until { @browser.text_field( :id, 'listingForm:newSic1').present? }

	#focus the field so we can get the javascript happy
	@browser.text_field( :id, 'listingForm:newSic1').focus
	@browser.text_field( :id, 'listingForm:newSic1').set data[ 'categoryKeyword' ]

	@browser.button( :value, 'Add new').when_present.click
	sleep(3)	
	if @browser.text_field(:id, 'listingForm:newSic1').text != ""
		@browser.button( :value, 'Add new').click #Try one more time hth!!
	end
	sleep(3)
	@browser.link( :text, 'Save').click
	sleep 15
	#Re-check if category was added.
	if @browser.text.include? "Category is required." #If we get the category is required message we try last time.
		@browser.button( :value, 'Add new').click
		sleep 10
		@browser.link( :text, 'Save').click
		30.times{ break if @browser.status == "Done"; sleep 1}
	elsif not @browser.text.include? "Thank you for updating our directory."
		@browser.link( :text, 'Save').click
		sleep 10
	end
	if @browser.text.include? "Thank you for updating our directory. Updates take effect within 3 business days. Check back for opportunities to upgrade your listing at that time."
		true
	else
		puts "Payload did not successfully complete"
	end
end

def main( data )
#this method runs the show
	@browser.goto('http://www.infopaginas.com/olc/lookup.faces')

	#enter the phone number
	@browser.text_field( :id, 'lookupForm:tel').when_present.set data[ 'phone' ]
	@browser.link( :id, 'lookupForm:submit').click

	if @browser.text.include? data[ 'business' ]
		puts ("Business already added.")
	else
		add_business(data)
	end
	true
end
main( data )