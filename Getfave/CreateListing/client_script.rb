#Search Business
@url = 'https://www.getfave.com/login'
@browser = Watir::Browser.new
@browser.goto(@url)
@browser.text_field( :id => 'session_email' ).set data[ 'email' ]
@browser.text_field( :id => 'session_password' ).set data[ 'password' ]
@browser.button(:value,'Log In').click
@browser.link(:id,'change-location').flash
@browser.link(:id,'change-location').when_present.click
@browser.text_field(:id, 'g-text-field').set data[ 'city' ] + ", " + data[ 'state' ]
@browser.button(:value,'Pin').click
#@browser.button(:value,'Pin').click
sleep(2)
queryurl = "https://www.getfave.com/search?utf8=%E2%9C%93&q=" + data[ 'bus_name_fixed' ]
puts(queryurl)
@browser.goto(queryurl)

Watir::Wait.until { @browser.div(:id,'results').exists? }
@results = @browser.div(:id,'results') 
@result_msg = "We couldn't find any matches."
@matching_result = @browser.div(:id,'business-results').span(:text,"#{data[ 'business' ] }")
if @results.exists? && @results.text.include?(@result_msg) || @matching_result.exist? == false
#Add business
	@browser.span(:text,'Add your business to Fave').click
	@browser.text_field( :id => 'business_name' ).set data[ 'business' ]
	@browser.text_field( :id => 'business_location' ).set data[ 'address' ]
	@browser.text_field( :id => 'business_phone_number' ).set data[ 'phone' ]
	@browser.text_field( :id => 'business_tags' ).set data[ 'keywords' ]
	@browser.link(:text,'Manage More Attributes').click
	@browser.text_field( :id => 'business_established' ).set data[ 'year' ]
	@browser.text_field( :id => 'business_tags' ).set data[ 'keywords' ]
	@browser.text_field( :id => 'business_tagline' ).set data[ 'tagline' ]
	@browser.text_field( :id => 'business_description' ).set data[ 'discription' ]
	@browser.text_field( :id => 'business_url' ).set data[ 'url' ]
	@browser.text_field( :id => 'business_email' ).set data[ 'business_email' ]
	@browser.text_field( :id => 'business_hours' ).set data[ 'business_hours' ]
	@browser.button(:value,'Publish Changes').click
	
true

end
