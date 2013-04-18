puts(data['category1'])
@browser.goto( 'http://submit.yippie.biz/' )

@browser.text_field( :name => 'businessname').set data['business']
@browser.text_field( :name => 'address').set data['addressComb']
@browser.text_field( :name => 'city').set data['city']
@browser.text_field( :name => 'state').set data['state']
@browser.text_field( :name => 'zipcode').set data['zip']
@browser.text_field( :name => 'telephone1').set data['areacode']
@browser.text_field( :name => 'telephone2').set data['exchange']
@browser.text_field( :name => 'telephone3').set data['last4']
@browser.text_field( :name => 'website').clear
@browser.text_field( :name => 'website').set data['website']
@browser.text_field( :name => 'email').set data['email']
@browser.select_list( :name => 'categories').click
@browser.select_list( :name => 'categories').option( :text => /#{data['category1']}/i).click

@browser.button( :value => 'Submit').click

if @browser.text.include? "Thank you for submitting your FREE business listing to YiPpIe!"
	true
end
