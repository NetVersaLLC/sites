@browser.goto('http://exportfocus.com/free-business-directory-listing1.php')

@browser.text_field( :name => 'field1').set data['business']
@browser.text_field( :name => 'field2').set data['email']
@browser.text_field( :name => 'phone').set data['phone']
@browser.select_list( :name => 'country').select data['country']
@browser.text_field( :name => 'field3').set data['city']
@browser.text_field( :name => 'field4').set data['zip']
@browser.text_field( :name => 'field5').set data['addressComb']
@browser.text_field( :name => 'field6').set data['fullname']

@browser.select_list( :name => 'industry').select data[ 'category1' ]
@browser.text_field( :name => 'mesg').set data['description']
@browser.text_field( :name => 'field7').set data['fullname']
@browser.button( :name => 'submit').click

true
