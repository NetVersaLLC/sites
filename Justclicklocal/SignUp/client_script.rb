@browser.goto( 'http://www.justclicklocal.com/user/join' )
@browser.text_field( :id => 'first_name').set data[ 'firstname' ]
@browser.text_field( :id => 'last_name').set data[ 'lastname' ]
@browser.text_field( :id => 'phone').set data[ 'phone' ]
@browser.text_field( :id => 'email').set data[ 'email' ]
@browser.text_field( :id => 'password').set data[ 'password' ]
@browser.text_field( :id => 'confirm_password').set data[ 'password' ]

@browser.button( :value => 'Log in').click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Justclicklocal'

if @chained
  self.start("Justclicklocal/CreateListing")
end

true
