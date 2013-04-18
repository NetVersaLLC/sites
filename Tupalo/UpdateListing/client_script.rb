goto_signin_page
process_tupalo_signin(data)

@browser.div(:xpath => '//*[@id="discovery-dashboard"]/form/div/ul/li[5]/div').when_present.click

@browser.span(:xpath => '//*[@id="coldspots_container"]/li[1]/div/div[2]/a/h2/span[2]').when_present.click
puts("before wait")
Watir::Wait.until { @browser.link(:text => /Is this your business?/).exists? or @browser.link(:text => /Edit this business/).exists? }
puts("after wait")
if @browser.link(:text => /Is this your business?/).exists?
	@browser.link(:text => /Is this your business?/).click
	@browser.link(:text => /Claim This Business Listing/).when_present.click

	@browser.div(:xpath => '//*[@id="discovery-dashboard"]/form/div/ul/li[5]/div').when_present.click

	@browser.span(:xpath => '//*[@id="coldspots_container"]/li[1]/div/div[2]/a/h2/span[2]').when_present.click


end
puts("1")
@browser.link(:text => /Edit this business/).when_present.click
puts("2")
@browser.text_field(:id => 'spot_name').when_present.set data['business']
@browser.text_field(:id => 'spot_street').set data['address']
sleep(3)
#@browser.text_field(:id => 'spot_city_and_country').set data['citystate']

@browser.text_field(:id => 'spot_city_and_country').clear

citystate = data['citystate'].split("")

citystate.each do |cs|
	@browser.text_field(:id => 'spot_city_and_country').send_keys cs
end
@browser.text_field(:id => 'spot_city_and_country').send_keys :tab


@browser.text_field(:id => 'spot_website').set data['website']
@browser.text_field(:id => 'spot_phone').set data['phone']

@browser.select_list(:xpath => '//*[@id="spot_category_input"]/select[1]').select data['category1']
sleep(3)
	if @browser.select_list(:id => 'sublevel_category').exists?
		@browser.select_list(:id => 'sublevel_category').select data['category2']
	end


@browser.button(:id => 'spot_submit').click

true


