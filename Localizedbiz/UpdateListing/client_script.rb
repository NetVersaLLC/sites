sign_in(data)

@browser.goto("http://www.localizedbiz.com/login/manage.php")

@browser.link(:text => /Edit/).click

@browser.text_field( :id => 'location_name').set data['business']
@browser.text_field( :name => 'address1').set data['address']
@browser.text_field( :name => 'city').set data['business']
@browser.select_list( :name => 'state').select data['state']
@browser.text_field( :name => 'zip1').set data['zip']
@browser.text_field( :name => 'areacode').set data['areacode']
@browser.text_field( :name => 'exchange').set data['exchange']
@browser.text_field( :name => 'phone').set data['last4']
@browser.text_field( :name => 'email').set data['email']

@browser.text_field( :name => 'url').set data['website']
@browser.select_list( :name => 'biz_cat1').select data['category1']
@browser.select_list( :name => 'biz_cat2').select data['category2']
@browser.text_field( :name => 'keywords').set data['keywords']
@browser.text_field( :name => 'tagline').set data['tagline']
@browser.text_field( :name => 'description').set data['description']

@browser.file_field( :name => 'new_image').set data['image']

@browser.button( :name => 'submit').click

Watir::Wait.until { @browser.text.include? "Data Successfully Updated" }

true