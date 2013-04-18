@browser.goto( 'https://www.gomylocal.com/add_listings.php?action=register&option=4' )
puts(data['category1'])
@browser.text_field( :name => 'user_name').set data['username']
@browser.text_field( :name => 'password').set data['password']
@browser.text_field( :name => 'confirm_password').set data['password']
@browser.text_field( :name => 'first_name').set data['fname']
@browser.text_field( :name => 'last_name').set data['lname']
@browser.text_field( :name => 't8').set data['email']
@browser.text_field( :name => 't1').set data['business']
@browser.text_field( :name => 't16').set data['addressComb']
@browser.text_field( :name => 't4').set data['city']
@browser.select_list( :name => 'c1').select data['state_name']
@browser.text_field( :name => 'txtZip').set data['zip']
@browser.text_field( :name => 't5').set data['phone']
@browser.text_field( :name => 't12').set data['keywords']

@browser.radio( :name => 'r1').click

@browser.text_field( :name => 'txtCategory').click
@browser.text_field( :name => 'search_txt').set data['category1']
@browser.image( :src => 'images/category_search.jpg').click
sleep(4)
@browser.frame( :name => 'Frame1').radio( :name => 'radiobutton' ).click
@browser.image( :src => 'images/category_submit.jpg').click

@browser.checkbox( :name => 'ch1').click

enter_captcha( data )

@browser.image( :name => 'imgFinish').click

if @browser.text.include? "Congratulations your listing is now activate."
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'account[username]' => data['username'], 'model' => 'Gomylocal'

	if @chained
		self.start("Gomylocal/Verify")
	end

true	

end


