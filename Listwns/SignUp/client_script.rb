@browser.goto( 'http://www.listwns.com/home/register.aspx' )

@browser.text_field( :id => 'email').set data[ 'email' ]
@browser.text_field( :id => 'pw1').set data[ 'password' ]
@browser.text_field( :id => 'pw2').set data[ 'password' ]

@browser.button( :id => 'btn').click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Listwns'

if @chained
	self.start("Listwns/Verify")
end

true

