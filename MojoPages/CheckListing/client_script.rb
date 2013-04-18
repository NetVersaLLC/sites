def search_for_business( data )

	#load the browser and navigate to the business search page
	@browser.goto('http://mojopages.com/biz/signup')

	#check if logout is needed
	@logout_needed = @browser.text.include? "Log Out"
	if @logout_needed
		#if logout is needed, log out and return to signup screen
	@browser.link( :text => 'Log Out' ).click

	#No need to wait until the new page loads, the logout signal is sent already.
	sleep 3
	
	#return to the business search page
	@browser.goto('http://mojopages.com/biz/signup')		
	end

	#enter phone number
  	@browser.text_field( :id => 'areaCode' ).set data[ 'phone_area' ]
	@browser.text_field( :name => 'exchange' ).set data['phone_prefix' ]
	@browser.text_field( :name => 'phoneNumber' ).set data[ 'phone_suffix' ]
	@browser.button( :value => 'Find My Business' ).click

end



def wait_for_results

#This function is a plagiarism of a method I saw in an example. it isn't really necessary but it helps with
#organization. 

#check if the search returned results - this will call the claim_business method
  @this_your_business = @browser.text.include? "Is this your business?"
  
  #No business found with that phone - this will call the add_business method
  @no_business_found = @browser.text.include? "We couldn't find your business based on phone number"
  
  #wait until one or the other is true
  Watir::Wait::until do
    @this_your_business or @no_business_found
  end

end



def main( data )

	#search for businesses and wait for result
 search_for_business( data )
 wait_for_results

if @this_your_business
	 puts("Business found, claiming it")
	if @chained
	  self.start("MojoPages/ClaimListing")
	end
	true
elsif  @no_business_found
	 puts("No business found, adding it")
	 if @chained
	  self.start("MojoPages/CreateListing")
	end
	 true
else
	 #if something else happens shut...down.....EVERYTHING
	 throw( 'Invalid condition after business search!' )
end


end


main( data )
