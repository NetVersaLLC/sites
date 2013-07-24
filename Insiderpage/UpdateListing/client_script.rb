def update_listing(data)
  true if update_business data
end

#*********************************
#MAIN CONTROLLER THINGY
#sign in
sign_in data

@browser.goto "http://www.insiderpages.com/my_profile/business"

Watir::Wait.until(120) {@browser.div(:class => 'business_info', :text => /#{data['business']}/i).exists?}
@browser.div(:class => 'business_info', :text => /#{data['business']}/i).link.click

true if update_listing data
