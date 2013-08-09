	@browser.goto('http://mojopages.com/biz/signup')		

	#enter phone number
  	@browser.text_field( :id => 'areaCode' ).set data[ 'phone_area' ]
	@browser.text_field( :name => 'exchange' ).set data['phone_prefix' ]
	@browser.text_field( :name => 'phoneNumber' ).set data[ 'phone_suffix' ]
	@browser.button( :value => 'Find My Business' ).click
sleep(10)


#check if the search returned results - this will call the claim_business method
  @this_your_business = @browser.text.include? "Is this your business?"
  
  #No business found with that phone - this will call the add_business method
  @no_business_found = @browser.text.include? "We couldn't find your business based on phone number"

  sleep(2)
  Watir::Wait::until do
    @this_your_business or @no_business_found
  end
  
  if @this_your_business
    businessFound['status'] = :claimed
    businessFound['listed_name'] = @browser.span(:class, "blue_header_text bold").h4.text
  elsif @no_business_found
    businessFound['status'] = :unlisted
  else
    businessFound['status'] = :unlisted
  end


return true, businessFound