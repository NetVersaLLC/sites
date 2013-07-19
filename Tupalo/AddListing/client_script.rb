goto_signin_page
process_tupalo_signin data
sleep 2

@browser.goto "http://tupalo.com/en/spots/new"
fill_listing_form data

sleep 5
Watir::Wait.until { @browser.text.include? "Thanks for adding the spot." }

if @chained
  self.start("Tupalo/ClaimListing")
end
true