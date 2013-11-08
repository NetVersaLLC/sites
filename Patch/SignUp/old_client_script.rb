url = find_site(data)

@browser.goto(url+"join")

@browser.text_field(:id => 'user_name').set data['name']
@browser.text_field(:id => 'user_email').set data['email']
@browser.text_field(:id => 'user_password').set data['password']

@browser.button(:id => 'user_submit').click

sleep(2)
#Watir::Wait.until {@browser.text.include? "Thanks for joining!" }
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Patch'
if @chained
	self.start("Patch/Verify")
end

true