sign_in(data)

@browser.goto("http://uscity.net/account/listing")

@browser.link(:text => 'Edit Listing').click


@browser.text_field(:name => 'Business_Name').when_present.set data[ 'business' ]
@browser.text_field(:name => 'Business_Web_Site').set data[ 'website' ]
@browser.text_field(:name => 'Address_Line_1').set data[ 'address' ]
@browser.text_field(:name => 'City').set data[ 'city' ]
@browser.select_list(:name => 'State_2_Letter_Abbr').select data['state']
@browser.text_field(:name => 'Postal_Code').set data[ 'zip' ]
@browser.text_field(:name => 'Main_Business_Phone').set data[ 'phone' ]
@browser.text_field(:name => 'Business_Description').set data[ 'business_description' ]
@browser.text_field(:name => 'Categories[]').set data[ 'category' ]
 
enter_captcha2(data)

sleep(5)
true