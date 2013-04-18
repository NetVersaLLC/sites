def add_listing( data )
	@browser.goto( 'http://insiderpages.com/businesses/new' )

	@browser.text_field( :id, 'business_name' ).set data[ 'business' ]
	@browser.text_field( :id, 'business_address_1' ).set data[ 'address' ]
	
	@browser.text_field( :name, 'city' ).set data[ 'city' ]
	sleep(2)
	@browser.li( :id => 'as-result-item-0', :index => 1).click

  
	@browser.select_list( :id, 'business_state_code' ).select data[ 'state' ]
	@browser.text_field( :id, 'business_zip_code' ).set data[ 'zip' ]
	@browser.text_field( :id, 'business_phone' ).set data[ 'phone' ]
	@browser.text_field( :id, 'business_email_address' ).set data[ 'business_email' ]
	@browser.text_field( :id, 'business_url' ).set data[ 'website' ]
	
	gories = data[ 'categories' ]
	gories.each do |categ| 
		if categ != ""
			@browser.text_field( :name, 'selected_categories').set categ
			@browser.text_field( :name, 'selected_categories').focus
			#@browser.li( :id, 'as-result-item-0').wait_until_present
			sleep(5)
			@browser.li( :id => 'as-result-item-0', :index => 1).click	
		end
	end
	
  
  #tags = data[ 'tags' ]
	#tags.each do |tag| 
	#	if tag != ""
	#		@browser.text_field( :name, 'selected_taggings').set tag
	#		@browser.text_field( :name, 'selected_taggings').focus
	#		sleep(5)
	#		@browser.li( :id => 'as-result-item-0', :index => 2).click	
	#	end
	#end
 
 @browser.radio( :id, 'yes').click
  puts("Committing")
	@browser.button( :name, "commit").click
	sleep(5)
  puts("After commit")
	if @browser.text.include? "You might be adding a duplicate"
		# adding a duplicate? Claim the business.
		claim_business( data )

	else
		update_business( data )	

	end
	

end

def claim_business( data )

	@browser.link( :text, /#{data['business']}/i).click
		@browser.link( :text, 'Claim Business').when_present.click
	@browser.div( :id, 'recaptcha_widget_div').wait_until_present
	enter_captcha( data )
	update_business( data )
true
end

def update_business( data )
#Regardless of the business existing or being added, this is the last step
		#all fields are optional
		@browser.text_field( :id, 'business_name' ).when_present.set data[ 'business' ]
		@browser.text_field( :id, 'business_email_address' ).set data[ 'business_email' ]
		@browser.text_field( :id, 'business_url' ).set data[ 'website' ]
		@browser.text_field( :id, 'business_merchant_attributes_bio' ).set data[ 'business_description' ]
		@browser.text_field( :id, 'business_merchant_attributes_services' ).set data[ 'services' ]
		@browser.text_field( :id, 'business_merchant_attributes_message' ).set data[ 'message' ]
		@browser.button( :value, 'update business' ).click
		true

end

#*********************************
#MAIN CONTROLLER THINGY
#sign in
sign_in( data )

#search for the business
@browser.text_field( :name, 'query').set data[ 'business' ]
@browser.text_field( :name, 'location').set data[ 'near_city' ]
@browser.button( :value, 'Search' ).click
@browser.select_list( :id, 'radius').wait_until_present

# Does the business already exist?
if @browser.link( :text, /#{data['business']}/i).exists?
#Claim the business
claim_business( data )
true
else
#add new listing
add_listing( data )
true
end

