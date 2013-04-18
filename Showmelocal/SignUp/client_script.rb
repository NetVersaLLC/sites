@browser.goto( 'http://www.showmelocal.com/businessregistration.aspx' )
puts(data['category'])
#business info


#personal info
@browser.text_field( :id => '_ctl0_txtFirstName').set data[ 'fname' ]
@browser.text_field( :id => '_ctl0_txtLastName').set data[ 'lname' ]
@browser.text_field( :id => '_ctl0_txtEmail').set data[ 'email' ]
#@browser.text_field( :id => '_ctl0_txtEmailConfirm').set data[ 'email' ]
@browser.text_field( :id => '_ctl0_txtPassword').set data[ 'password' ]

	enter_captcha( data )

@browser.text_field( :id => '_ctl0_txtBusinessName').when_present.set data[ 'business' ]
@browser.text_field( :id => '_ctl0_txtBusinessType').set data[ 'category' ]
#@browser.text_field( :id => 'txtType').set data[ 'type' ]
@browser.text_field( :id => '_ctl0_txtPhone').set data[ 'phone' ]
@browser.text_field( :id => '_ctl0_txtAddress').set data[ 'address' ]
@browser.text_field( :id => '_ctl0_txtAddress2').set data[ 'address2' ]
#@browser.text_field( :id => '_ctl3_txtCity').set data[ 'city' ]
#@browser.select_list( :id => '_ctl3_cboState').select data[ 'state' ]
@browser.text_field( :id => '_ctl0_txtZip').set data[ 'zip' ]


#@browser.checkbox( :id => 'chkAgree').click
	enter_captcha( data )


RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Showmelocal'
	if @chained
		self.start("Showmelocal/Verify")
	end
true
