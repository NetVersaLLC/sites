sign_in(data)

sleep(2)

@browser.goto("http://biz.yellowee.com/dashboard")
@browser.link(:id => 'basic_business').click

@browser.text_field( :id => 'id_name').when_present.set data[ 'business' ]
@browser.text_field( :id => 'id_address').set data[ 'address' ]
@browser.text_field( :id => 'id_apartment').set data[ 'address2' ]
@browser.text_field( :id => 'location_autocomplete').set data[ 'query' ]
@browser.text_field( :id => 'id_postal_code').set data[ 'zip' ]
@browser.text_field( :id => 'id_phone').set data[ 'phone' ]
@browser.text_field( :id => 'id_website').set data[ 'website' ]

@browser.link(:class => 'remove_category').click
sleep(1)
@browser.select_list( :name => 'category1_1').select data['cat1']
sleep(4)
@browser.select_list( :name => 'category1_2').select data['cat2']

@browser.button(:id => 'submit').click

Watir::Wait.until { @browser.text.include? "The business has been edited." }

true
