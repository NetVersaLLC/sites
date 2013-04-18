@browser.goto( 'http://www.expressbusinessdirectory.com/AddYourBusiness.aspx' )

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusinessName').set data['business']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtAddress1').set data['address']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtAddress2').set data['address2']

@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_cboCountry').select data['country']
sleep(2)
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_cboState').select data['state']
sleep(2)
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_cboCity').select data['city']

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtZip').set data['zip']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdStep1Next').click

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPhone').when_present.set data[ 'phone' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtFax').set data[ 'fax' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusinessEmail').set data[ 'email' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtFax').set data[ 'fax' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtUrl').set data[ 'website' ]

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdStep2Next').click

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusinessDesc').when_present.set data['description']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdStep3Next').click

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusinessKeywords').set data['keywords']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdStep4Next').click

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtFName' ).when_present.set data['fname']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtLName' ).set data['lname']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtEmail' ).set data['email']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtVerifyEmail' ).set data['email']
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_cboJobFunction' ).select data['position']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdClaim').click

if @browser.text.include? 'Almost there......Now check your email'
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'model' => 'Expressbusinessdirectory'
	if @chained
		self.start("Expressbusinessdirectory/Verify")
	end
true

end





