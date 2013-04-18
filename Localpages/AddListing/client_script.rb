sign_in(data)

@browser.goto('http://www.localpages.com/add_edit_business_info.php')

@browser.text_field( :id => 'business_name').set data['business']
@browser.select_list( :id => 'category_1').select data['category1']
sleep(3)
@browser.select_list( :id => 'category_2').select data['category2']

@browser.text_field( :name => 'address_1').set data['address']
@browser.text_field( :name => 'address_2').set data['address2']
@browser.text_field( :name => 'city').set data['city']

@browser.select_list( :name => 'state').select data['state']
@browser.text_field( :name => 'zip').set data['zip']
@browser.text_field( :name => 'phone').set data['phone']
@browser.text_field( :name => 'website').set data['website']

@browser.link( :text => /Save Changes/i).click

true
