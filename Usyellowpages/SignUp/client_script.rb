@browser.goto("https://www.usyellowpages.com/Admin/Reg.aspx?Action=Register")

@browser.text_field(:name => 'Email').set data['email']
@browser.text_field(:name => 'UserName').set data['username']
@browser.text_field(:name => 'Password').set data['password']
@browser.text_field(:name => 'ConfirmPassword').set data['password']

@browser.button(:value => 'Submit').click

sleep 2
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'username' ], 'account[password]' => data['password'], 'model' => 'Usyellowpages'

Watir::Wait.until {@browser.text.include? "Browse by State in the US Yellow Pages"}

if @chained
	self.start("Usyellowpages/AddListing")
end
true