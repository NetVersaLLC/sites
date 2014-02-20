@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

@browser.goto( "http://www.yellowbot.com/" )
@browser.text_field( :id => 'search-field' ).set data[ 'phone' ]
@browser.button( :value => 'Find my business' ).click #, :type => 'submit'

Watir::Wait.until do 
  @browser.link( :text => 'submit a new business').exists? || 
  @browser.link( :text => 'Claim' ).exists?
end 

if @browser.link( :text => 'submit a new business').exists?

	puts("No business, adding now")
	if @chained
	  self.start("Yellowbot/CreateListing")
	end
# Claim existing business
elsif @browser.link( :text => 'Claim' ).exists?

	puts("Business exists, claiming")
	if @chained
	  self.start("Yellowbot/Notify")
	end
	true
else
 throw( "Problem with locating link to continue YellowBot registration!" )
end
self.success
