@browser.goto(data[ 'url' ])

@browser.text_field( :id => 'uname').when_present.set data[ 'username' ]
@browser.text_field( :id => 'password').set data['password']

@browser.link( :text => 'sign in').click

@browser.text_field( :id => 'password').when_present.set data['permPass']
@browser.text_field( :id => 'confirmPassword').set data['permPass']

@browser.link( :text => 'continue').click
sleep(10)
if @browser.text.include? "Success! You have claimed your business listing"
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data[ 'permPass' ], 'account[username]' => data[ 'username' ], 'model' => 'Supermedia'
	true
end
