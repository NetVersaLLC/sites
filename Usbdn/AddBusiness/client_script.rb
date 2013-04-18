@browser.goto( 'http://usbdn.com/BizRegistrationStep1.asp?' )

@browser.text_field( :id => 'SearchW').set data[ 'category1' ]
@browser.button( :id => 'Image1').click

@browser.image( :src => 'images/select.gif', :index => 0).when_present.click

@browser.image( :src => 'images/Continue.gif').when_present.click

@browser.text_field( :id => 'Nick').set data['business']
@browser.text_field( :id => 'URL').set data['fakeurl']
@browser.select_list( :name => 'RegionId').select data['state']
sleep(3)
@browser.select_list( :name => 'CityId').select data['city']
@browser.text_field( :name => 'StreetName').set data['address']
@browser.text_field( :name => 'Zip').set data['zip']
@browser.text_field( :name => 'Phone').set data['phone']
@browser.text_field( :name => 'OtherPhone').set data['altphone']
@browser.text_field( :name => 'Fax').set data['fax']

@browser.text_field( :name => 'Email').set data['email']
@browser.text_field( :name => 'WebSite').set data['website']
@browser.text_field( :name => 'Description').set data['description']
@browser.text_field( :name => 'Fax').set data['fax']

@browser.text_field( :name => 'UserName').set data['fakeurl']
@browser.text_field( :name => 'Password').set data['password']
@browser.text_field( :name => 'PasswordConfirm').set data['password']

@browser.button( :id => 'send').click
if @browser.alert.text == "Attention! After your registration process a confirmation email will be sent to your email address. Please verify your email address"
	@browser.alert.ok
else
	throw("Form error")
end

puts(data['password'])

if @browser.text.include? 'Thank you for Registering USBDN.com.'
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['fakeurl'], 'account[password]' => data['password'], 'model' => 'Usbdn'
#	if @chained
#		self.start("Usbdn/Verify")
#	end
	true
end


