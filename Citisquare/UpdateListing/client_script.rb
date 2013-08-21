# Main Script start from here
# Launch url
url = 'http://citysquares.com/user/login'
@browser.goto url
30.times{break if @browser.status == "Done"; sleep 1}

login data

@browser.link(:text => 'My Businesses').click
30.times{break if @browser.status == "Done"; sleep 1}

# @browser.link(:text => /#{data['business']}/).click if @browser.div(:id => 'ownedMenuHome').exist?
if @browser.element(:css, "li a").present?	
	@browser.element(:css, "div#ownedMenuHome ul li a").click
end

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
30.times{break if @browser.status == "Done"; sleep 1}

puts "Updating phone information"
@browser.link(:text => 'Phone Numbers').click
@browser.text_field(:name => 'areacode').set data['phone_area']
@browser.text_field(:name => 'exchange').set data['phone_prefix']
@browser.text_field(:name => 'phonenumber').set data['phone_suffix']
@browser.button(:text => 'Save').click

30.times{break if @browser.status == "Done"; sleep 1}

puts "Updating category information"
@browser.link(:text => 'Category').when_present.click
@browser.select_list(:name => 'top_cat').select data['category']
sleep(3)
@browser.select_list(:name => 'inet_cat').option.wait_until_present
@browser.select_list(:name => 'inet_cat').when_present.select data['sub_category']
@browser.button(:text => 'Save').when_present.click

30.times{break if @browser.status == "Done"; sleep 1}

true