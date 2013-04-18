sign_in(data)


@browser.goto("https://adsolutions.yp.com/listings/Overview")

@browser.link(:href => /Business/).click

@browser.text_field(:id => 'BusinessName').when_present.set data['business']
@browser.text_field(:id => 'BusinessOwnerFirstName').set data['fname']
@browser.text_field(:id => 'BusinessOwnerLastName').set data['lname']


@browser.text_field(:id => 'BusinessAddress_Address1').set data['address']
@browser.text_field(:id => 'BusinessAddress_City').set data['city']
@browser.select_list(:id => 'BusinessAddress_State').select data['state']
@browser.text_field(:id => 'BusinessAddress_Zipcode').set data['zip']
@browser.text_field(:id => 'BusinessYear').set data['founded']

@browser.button(:src => 'https://si.yellowpages.com/D49_ascp-btn-cont-blue_V1.png').click
sleep(4)
true
