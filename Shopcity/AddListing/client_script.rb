puts(data[ 'category1' ])

@browser.goto("http://www.shopcity.com/map/mapnav_locations.cfm?")

@browser.link( :text => /#{data['country']}/).click
@browser.link( :text => /#{data['state']}/).click
@browser.link( :text => /#{data['cityState']}/).click	
@browser.link( :title => 'Login').click
@browser.text_field( :name => 'email').set data['email']
@browser.text_field( :name => 'pw').set data['password']
sleep(2)
@browser.link( :text => "Sign Me In").click
sleep(2)
@browser.link( :title => 'Add Business').click
sleep(2)
@browser.link( :xpath => '//*[@id="mainpage"]/table[1]/tbody/tr[5]/td/table/tbody/tr[1]/td[1]/table/tbody/tr[2]/td/a[3]').click
sleep(2)
@browser.text_field( :id => 'subfolder_name').set data['siteName']

sleep(3)
@browser.link( :title => 'GET STARTED!').click
if @browser.alert.exists?
	@browser.alert.ok
end

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
@browser.checkbox( :name => 'agree').click
@browser.button( :value => /Next/).click
sleep(3)
@browser.text_field( :id => 'searchCategories').set data['category1']
@browser.select_list( :id => 'SelectList').option( :index => 0).click
@browser.img( :title => 'Add to List').click
sleep(2)
@browser.button( :value => /Next/, :index => 1).click
sleep(3)
@browser.button( :value => /Next/, :index => 2).click
sleep(3)

payments = data[ 'payments' ]
payments.each do |payment|
	@browser.checkbox( :id => payment).click
end
@browser.button( :value => /Next/, :index => 3).click

sleep(3)

@browser.text_field( :name => 'sitetitle').set data['business']
@browser.button( :value => /Next/, :index => 4).click
sleep(3)
@browser.button( :value => /Next/, :index => 5).click
sleep(3)
@browser.button( :value => /Finish/).click

true
