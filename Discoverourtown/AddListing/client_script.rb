def add_listing(data)
	@browser.text_field(:name => 'ListContact').set data[ 'full_name' ]
	@browser.text_field(:name => 'ReqEmail').set data[ 'email' ]
	@browser.text_field(:name => 'ListOrgName').set data[ 'business' ]
	@browser.text_field(:name => 'ListAddr1').set data[ 'address' ]
	@browser.text_field(:name => 'ListCity').set data[ 'city' ]
	@browser.text_field(:name => 'ListState').set data[ 'state' ]
	@browser.text_field(:name => 'ListZip').set data[ 'zip' ]
	@browser.text_field(:name => 'ListPhone').set data[ 'phone' ]
	@browser.text_field(:name => 'ListWebAddress').set data[ 'website' ]
	@browser.text_field(:name => 'ListStatement').set data[ 'business_description' ]

	#Enter Decrypted captcha string here
	enter_captcha( data )

	@browser.link(:href => 'thankyou.php').click

	@confirmation_msg = 'Your submission was successful and has now been sent to our review department.'

	if @browser.text.include?(@confirmation_msg)
		puts "Initial registration Successful"
		RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'username' ],'model' => 'Discoverourtown'
		else
		throw "Initial registration not successful"
	end
end

# Main Steps

# Launch url
url = 'http://www.discoverourtown.com/add/'
@browser.goto(url)

if search_business(data)
  add_listing(data)
else
  puts "Business Already Exist"
end
