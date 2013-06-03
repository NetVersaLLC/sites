@browser.goto( 'http://www.expressbusinessdirectory.com/login.aspx' )
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtEmail').set data['email']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdLogin').click
sleep 2
@browser.link( :text => "#{data[ 'business' ]}").when_present.click
sleep 2
Watir::Wait.until {@browser.link(:id => 'ctl00_hypEditBusiness').exists?}
#Begin verifying location
@browser.link( :id => 'ctl00_ContentPlaceHolder1_A4').click
sleep(2)
@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdSaveMap').click
sleep(5)
@browser.goto('http://www.expressbusinessdirectory.com/member/home.aspx')

## Waiting on required fields in business form to complete this section
#Begin adding a product  
#@browser.link( :id => 'ctl00_ContentPlaceHolder1_A7').click
#@browser.button( :href => 'EditProduct.aspx').click
#sleep(2)
#@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtProductName').set data[ 'product' ]
#@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtProductKeywords').set data[ 'tags' ]

#Add a photo
#@browser.link( :id => 'ctl00_ContentPlaceHolder1_A8').click
#sleep(2)
#@browser.file_field( :id => 'ctl00_ContentPlaceHolder1_txtTitle').set data['logo']

#Begin verifying email
@browser.goto('http://www.expressbusinessdirectory.com/member/home.aspx')
@browser.link( :id => 'ctl00_ContentPlaceHolder1_A1').click
sleep(2)
@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdVerify').click

	if @chained
		self.start("Expressbusinessdirectory/VerifyEmail")
	end

true