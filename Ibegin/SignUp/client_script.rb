@browser.goto('http://www.ibegin.com/account/register/')

@browser.text_field( :name, 'name').set data[ 'username' ]
@browser.text_field( :name, 'liame').set data[ 'email' ]
@browser.text_field( :name, 'pw' ).set data[ 'password' ]

@browser.button( :value, /Register/i).click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Ibegin'

	if @chained
		self.start("Ibegin/CreateListing")
	end

true

