goto_signin_page
process_tupalo_signin(data)
puts 'ping'
sleep(2)

@browser.goto("http://tupalo.com/en/spots/new")
puts 'ping'
@browser.text_field(:id => 'spot_name').set data['business']
@browser.text_field(:id => 'spot_street').set data['address']
puts 'ping'
sleep(3)
#@browser.text_field(:id => 'spot_city_and_country').set data['citystate']

@browser.text_field(:id => 'spot_city_and_country').clear

@browser.text_field(:id => 'spot_city_and_country').send_keys data['citystatecountry']
sleep 5

@browser.select_list(:id => 'spot_city_and_country').select data['category1']

@browser.send_keys :enter

sleep 3

@browser.text_field(:id => 'spot_website').set data['website']
@browser.text_field(:id => 'spot_phone').set data['phone']

@browser.select_list(:xpath => '//*[@id="spot_category_input"]/select[1]').select data['category1']
sleep(3)
	if @browser.select_list(:id => 'sublevel_category').exists?
		@browser.select_list(:id => 'sublevel_category').select data['category2']
	end

@browser.button(:name => 'commit').click

sleep 10
true

#Claim This Business Listing – Free
#Is this your business?