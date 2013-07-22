goto_signup_page
process_tupalo_signup(data)

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'model' => 'Tupalo'

if @chained
	self.start("Tupalo/Verify")
end
true