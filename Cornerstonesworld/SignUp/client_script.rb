puts(data['category'])
@browser.goto( 'http://www.cornerstonesworld.com/index.php?page=addurl' )

@browser.text_field( :id => 'cname').set data[ 'business' ]
@browser.select_list( :id => 'cat').select data['category']	
@browser.text_field( :id => 'addrcl').set data[ 'address' ]
@browser.text_field( :id => 'citycl').set data[ 'city' ]
@browser.text_field( :id => 'zipcl').set data[ 'zip' ]
@browser.select_list( :id => 'countrycl').select data['country']
@browser.select_list( :id => 'state').when_present.select data['state']
@browser.text_field( :id => 'phonecl').set data[ 'phone' ]
@browser.text_field( :id => 'phone2cl').set data[ 'phone2' ]
@browser.text_field( :id => 'faxcl').set data[ 'fax' ]
@browser.text_field( :id => 'mphonecl').set data[ 'mobilephone' ]
@browser.text_field( :id => 'web').set data[ 'website' ]
@browser.text_field( :id => 'emailcl').set data[ 'email' ]

@browser.text_field( :id => 'namecl').set data[ 'name' ]
@browser.text_field( :id => 'snamecl').set data[ 'namelast' ]
@browser.select_list( :id => 'sexcl').select data[ 'gender' ]
@browser.text_field( :id => 'jobcl').set data[ 'jobtitle' ]
@browser.checkbox( :id => 'newsch').click

enter_captcha( data )


RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'model' => 'Cornerstonesworld'
	if @chained
		self.start("Cornerstonesworld/Verify")
	end
true


