sign_in(data)
sleep(5) # let signin process.. its an ajax request
@browser.link(:text => 'My Biz').when_present.click

@browser.link(:text => 'Contact Info').when_present.click

@browser.text_field( :name => 'businessname').when_present.set data['business']
@browser.text_field( :name => 'contact').set data['fulleName']
@browser.text_field( :name => 'address1').set data['address']
@browser.text_field( :name => 'address2').set data['address2']
@browser.text_field( :name => 'city').set data['city']
@browser.text_field( :name => 'province').set data['state_name']
@browser.text_field( :name => 'country').set data['country']
@browser.text_field( :name => 'postal').set data['zip']
@browser.text_field( :name => 'phone').set data['phone']
@browser.text_field( :name => 'fax').set data['fax']
@browser.text_field( :name => 'tollfree').set data['tollfree']
@browser.text_field( :name => 'email').set data['email']

@browser.link(:text => 'Save Changes').click


true