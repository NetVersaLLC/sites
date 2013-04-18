@browser.goto('http://www.supermedia.com/spportal/quickbpflow.do')

@browser.text_field( :name => 'phone').set data['phone']
@browser.link( :id => 'getstarted-search-btn').click

@browser.link( :text => 'select', :index => 0 ).when_present.click
@browser.link( :text => 'next', :index => 0 ).when_present.click

@browser.text_field( :id => 'busname').set data['business']
@browser.text_field( :id => 'address1Id').set data['addressComb']
@browser.text_field( :id => 'cityId').set data['city']
@browser.select_list( :id => 'stateId').select data['state']
@browser.text_field( :id => 'zipId').set data['zip']
@browser.text_field( :id => 'wsurl').set data['website']
@browser.text_field( :id => 'searchtext').set data['category1']
@browser.link( :text => 'search').click
@browser.span( :class => 'addlink', :index => 0).when_present.click

@browser.text_field( :name => 'customerProfile.firstname').set data['fname']
@browser.text_field( :name => 'customerProfile.lastname').set data['lname']
@browser.text_field( :id => 'account-email').set data['email']
@browser.text_field( :id => 'emailconfirm').set data['email']

enter_captcha( data )

@browser.checkbox( :id => 'acceptterms').when_present.click
@browser.link(:id => 'popup_ok').click

sleep(5)
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'model' => 'Supermedia'

	if @chained
		self.start("Supermedia/Verify")
	end
true

