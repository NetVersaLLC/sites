@browser.goto( 'http://www.snoopitnow.com/Create-new-item.html' )

@browser.text_field( :id => 'field_entry_name').set data[ 'business' ]
@browser.text_field( :id => 'field_street').set data[ 'address' ]
@browser.text_field( :id => 'field_address2').set data[ 'address2' ]
@browser.text_field( :id => 'field_area').set data[ 'suburb' ]
@browser.text_field( :id => 'field_state').set data[ 'state' ]
@browser.text_field( :id => 'field_postcode').set data[ 'zip' ]
@browser.text_field( :id => 'field_country').set data[ 'country' ]
@browser.text_field( :id => 'field_phone').set data[ 'phone' ]
@browser.text_field( :id => 'field_fax').set data[ 'mobile' ]
@browser.text_field( :id => 'field_county').set data[ 'fax' ]
@browser.text_field( :id => 'field_email').set data[ 'email' ]
@browser.text_field( :id => 'field_website').set data[ 'website' ]
@browser.text_field( :id => 'field_contact_person').set data[ 'fullname' ]
@browser.text_field( :id => 'sobi2MetaKey').set data[ 'keywords' ]
@browser.select_list( :name => 'backgroundimage').select "blue.gif"
@browser.text_field( :id => 'test_catinput').set data[ 'category1' ]

@browser.execute_script("document.getElementById('test_catid').value = '170';")
sleep(2)
#@browser.ul( :id => 'as_ul').when_present.li( :index => 1).when_present.click
@browser.button( :id => 'sobi2AddCatBt').click

@browser.button( :id => 'sobi2SendButton').click

if @browser.text.include? "Your details has been submitted. It will be processed and published by snoopitnow administrator shortly"

	true

end
