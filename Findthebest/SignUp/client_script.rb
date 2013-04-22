@browser.goto("http://www.findthebest.com/")

sleep 5
@browser.execute_script("create_account_form();")

sleep(3)

@thebox = @browser.div(:id => 'user_register')

puts(@thebox.to_s)
@thebox.text_field(:id => 'edit-name').set data['username']
@thebox.text_field(:id => 'edit-mail').set data['email']
@thebox.text_field(:id => 'edit-pass').set data['password']
@thebox.checkbox(:name => 'agree_tc').click
enter_captcha(@thebox)

sleep(2)

	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Findthebest'
	true
