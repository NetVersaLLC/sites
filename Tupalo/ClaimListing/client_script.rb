goto_signin_page
process_tupalo_signin data

@browser.li(:class => 'navItem logged_in tinyUser').link.click

@browser.div(:xpath => "//*[@data-filter='discovered_spots']").click
@browser.link(:text => /#{data['business']}/).click

@browser.link(:text => /Is this your business?/).click
@browser.link(:text => /Claim this business now/).click

Watir::Wait.until { @browser.h1(:text => /#{data["business"]}/).exist? }
true