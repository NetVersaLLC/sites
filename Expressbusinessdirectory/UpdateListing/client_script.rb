@browser.goto( 'http://www.expressbusinessdirectory.com/login.aspx' )
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtEmail').set data['email']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdLogin').click

@browser.link( :text => "#{data[ 'business' ]}").click

Watir::Wait.until {@browser.link(:id => 'ctl00_hypEditBusiness').exists?}

@browser.link(:id => 'ctl00_hypEditBusiness').click
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtAddress1').set data['address']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtAddress2').set data['address2']
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_cboCountry').select data['country']
sleep(2)
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_cboState').select data['state']
sleep(2)
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_cboCity').select data['city']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtZip').set data['zip']

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPhone').when_present.set data[ 'phone' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtFax').set data[ 'fax' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusinessEmail').set data[ 'email' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtFax').set data[ 'fax' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtUrl').set data[ 'website' ]
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusinessDesc').when_present.set data['description']

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusinessKeywords').set data['keywords']
@browser.link(:id => 'ctl00_ContentPlaceHolder1_cmdSave').click

Watir::Wait.until { @browser.text.include? "Your Business Profile is" }
true
