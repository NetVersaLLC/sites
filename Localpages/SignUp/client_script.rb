@browser.goto('http://www.localpages.com/signup/')

@browser.execute_script("
			oFormObject = document.forms['signup1'];
			oFormObject.elements['username'].value = '#{data['username']}';
			oFormObject.elements['email'].value = '#{data['email']}';		
			")
@browser.radio( :xpath => '/html/body/div[2]/div/div[3]/div[2]/div/form/div/p[5]/input[2]').click
@browser.link( :text => 'Register').click

	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['username'], 'model' => 'Localpages'
	if @chained
		self.start("Localpages/Verify")
	end

true