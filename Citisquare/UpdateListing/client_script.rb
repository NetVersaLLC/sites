# Main Script start from here
# Launch url
url = 'http://citysquares.com/user/login'
@browser.goto url

login data

@browser.link(:text => 'My Businesses').click

# @browser.link(:text => /#{data['business']}/).click if @browser.div(:id => 'ownedMenuHome').exist?
@browser.link(:text => 'Edit').click


puts "Updating address information"
@browser.text_field(:name => 'standardname').set data['business']
@browser.text_field(:name => 'number').set data['street_number']
@browser.text_field(:name => 'predir').set data['predirection']
@browser.text_field(:name => 'street').set data['street']
@browser.text_field(:name => 'strtype').set data['street_type']
@browser.text_field(:name => 'postdir').set data['postdirection']
@browser.text_field(:name => 'apttype').set data['apt_type']
@browser.text_field(:name => 'aptnbr').set data['apt_number']
@browser.text_field(:name => 'boxnbr').set data['box_number']
@browser.text_field(:name => 'cityname').set data['city']
@browser.select_list(:name => 'state').select data['state']
@browser.text_field(:name => 'zip').set data['zip']
@browser.button(:text => 'Save').click

Watir::Wait.until { @browser.text.include? "has been updated. Click here to view your profile." }

puts "Updating phone information"
@browser.link(:text => 'Phone Numbers').click
@browser.text_field(:name => 'areacode').set data['phone_area']
@browser.text_field(:name => 'exchange').set data['phone_prefix']
@browser.text_field(:name => 'phonenumber').set data['phone_suffix']
@browser.button(:text => 'Save').click

Watir::Wait.until { @browser.text.include? "has been updated. Click here to view your profile." }

puts "Updating category information"
@browser.link(:text => 'Category').click
@browser.select_list(:name => 'top_cat').select data['category']
sleep(3)
@browser.select_list(:name => 'inet_cat').select data['sub_category']
@browser.button(:text => 'Save').click

Watir::Wait.until { @browser.text.include? "has been updated. Click here to view your profile." }

true