goto_signin_page
process_tupalo_signin data

@browser.li(:class => 'navItem logged_in tinyUser').link.click
@browser.div(:xpath => "//*[@data-filter='discovered_spots']").click
@browser.link(:text => /#{data['business']}/).click
@browser.link(:text => /Edit this business/).when_present.click

fill_listing_form data

sleep 5
Watir::Wait.until { @browser.text.include? "Thanks for updating the spot information." }
true