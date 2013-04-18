sign_in(data)

@browser.link(:text => 'Edit Listing').when_present.click

@browser.link(:id => 'edit_business_add').when_present.click

@browser.text_field(:id => 'company').set data['business']
@browser.text_field(:id => 'street').set data['address']
@browser.text_field(:id => 'street2').set data['address2']
@browser.text_field(:id => 'city').set data['city']
@browser.text_field(:id => 'zip').set data['zip']
@browser.select_list(:id => 'state').select data['state_name']

@browser.button(:id => 'btnSubBusInfo').click

@browser.link(:xpath => '//*[@id="payment_option"]/a').click

data['payments'].each do |pay|
	@browser.checkbox(:name => pay).clear
	@browser.checkbox(:name => pay).click
end

@browser.button(:id => 'btnSubPayDesc').click

Watir::Wait.until {@browser.text.include? "Payment Options have been saved."}

true








