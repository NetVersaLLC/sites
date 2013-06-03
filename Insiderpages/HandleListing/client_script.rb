def add_listing(data)
  # @browser.link(:text => 'Add a New Business').click
  @browser.goto 'http://www.insiderpages.com/businesses/new'

  fill_form data

  @browser.radio(:id => 'yes').click
  puts "Committing"
  @browser.button(:text => 'Submit & Go to Step 2').click
  puts "After commit"

  sleep 5

  if @browser.div(:id => 'possible_duplicates').text.include? data['business']
    @browser.link(:text => data['business']).click
  else
    @browser.button(:id => 'add_potential_duplicate').click
    @browser.alert.ok
  end
  
  sleep 5
  Watir::Wait.until { @browser.div(:class => 'item vcard').exist? }

  true if claim_business data
end

def claim_business(data)
  raise Exception, 'Business cannot be claimed.' unless @browser.text.include? 'Claim Business'

  @browser.link(:text => 'Claim Business').when_present.click
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
