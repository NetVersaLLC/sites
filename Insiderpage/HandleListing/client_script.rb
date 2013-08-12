def add_listing(data)
  # @browser.link(:text => 'Add a New Business').click
  @browser.goto 'http://www.insiderpages.com/businesses/new'

  fill_form data

  @browser.radio(:id => 'yes').click
  puts "Committing"
  @browser.button(:text => 'Submit & Go to Step 2').click
  puts "After commit"

  sleep 3
  Watir::Wait.until { @browser.text.include? "You might be adding a duplicate" or @browser.text.include? 'Congratulations on updating your business on Insider Pages.'}

  if @browser.text.include? "You might be adding a duplicate"
    @browser.button(:id => 'add_potential_duplicate').click  
    sleep 3
    @browser.alert.ok
  	sleep 15
  	#Watir::Wait.until { @browser.link(:text => 'Write a Review').exists? }
  	true if claim_business(data)
  end
  	#Watir::Wait.until(10) { @browser.text_field(:id => 'business_name').exists? }
  	#@browser.text_area(:id, 'business_merchant_attributes_bio').set data['business_description']
  	#if self.logo.nil?
  	#	puts "No Logo"
  	#else
  	#	begin
  	#	@browser.file_field(:id, "business_photos_attributes_99_uploaded_data").set self.logo
  	#	rescue
  	#		puts "Error in setting logo."
  	#	end
  	#end

  	# Hours
  	#hours = InsiderPage.get_hours
  	#@browser.ul(:class, 'addresses').li.address.click
  	#@browser.checkboxes.each { |checkbox| checkbox.clear }
  	#@browser.text_field(:id, 'business_addresses_attributes_0_hours_attributes_mon_opens_at_formatted').set hours["monday", "open"]
  #end
end

def claim_business(data)
  raise Exception, 'Business cannot be claimed.' unless @browser.text.include? 'Claim Business'

  @browser.link(:text => 'Claim Business').when_present.click
  sleep 2
  Watir::Wait.until { @browser.div(:id => 'recaptcha_widget_div').exist? }
  enter_captcha data
  sleep 5

  true if update_business data
end

#*********************************
#MAIN CONTROLLER THINGY
#sign in
sign_in data

#add new listing
true if add_listing data
