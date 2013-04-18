@browser.goto( 'https://account.nokia.com/acct/register?serviceId=PrimePlaces' ) 
@browser.text_field( :id => 'email').set data['email']
@browser.text_field( :id => 'newPassword').set data['password']
@browser.text_field( :id => 'newPasswordVerify').set data['password']
@browser.select_list( :id => 'country').select data['country']
@browser.select_list( :id => 'dobMonth').select data['birth1'].sub(/^0/, "")
@browser.select_list( :id => 'dobDay').select data['birth2'].sub(/^0/, "")
@browser.select_list( :id => 'dobYear').select data['birth3'].sub(/^0/, "")


enter_captcha( data )

if @browser.text.include? "You've successfully created a Nokia account. You can start exploring Nokia services right now."

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Primeplace'

	if @chained
		self.start("Primeplace/AddListing")
	end
	true
end

