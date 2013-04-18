sign_in(data)

@browser.goto( 'http://primeplace.nokia.com/place/create' )

if @browser.link( :text => /Accept/i).exists?
	@browser.link( :text => /Accept/i).click
end

@browser.text_field( :id => 'name').when_present.set data['business']
@browser.select_list( :id => 'country').select data['country']
sleep(2)
@browser.text_field( :id => 'number').set data['address2']
@browser.text_field( :id => 'street').set data['address']
@browser.select_list( :id => 'province').select data['state_name']
@browser.text_field( :id => 'postalCode').set data['zip']
@browser.text_field( :id => 'city').set data['city']

puts(data['category1'])
puts(data['category2'])
@browser.select_list( :id => 'level1Category').select data['category1']
sleep(1)
@browser.select_list( :id => 'level3Category').select data['category2']

@browser.button( :id => 'add_place').click

if @browser.link( :text => /Accept/i).exists?
	@browser.link( :text => /Accept/i).click
end

@browser.button( :id => 'verifyPostcard').when_present.click

true