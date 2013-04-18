@browser.goto( "http://www.yellowbot.com/" )
@browser.text_field( :id => 'search-field' ).set data[ 'phone' ]
@browser.button( :value => 'Find my business' ).click #, :type => 'submit'

sleep(5)

if @browser.link( :text => 'submit a new business').exists?

	puts("No business, adding now")
	if @chained
	  self.start("Yellowbot/CreateListing")
	end
# Claim existing business
elsif @browser.link( :text => 'Claim' ).exists?

	puts("Business exists, claiming")
	if @chained
	  self.start("Yellowbot/ClaimListing")
	end
	true
else
 throw( "Problem with locating link to continue YellowBot registration!" )
end
true
