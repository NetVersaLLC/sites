@browser.goto( 'http://www.localndex.com/claim/addnew.aspx' )
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusName').set data['business']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusAddress').set data['address']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusCity').set data['city']
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_ddlBusState').select data['state']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusPhone').set data['phone']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusZip').set data['zip']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusTollFree').set data['tollfree']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusEmail').set data['email']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusWebsite').set data['website']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtUserEmail').set data['email']

enter_captcha( data )


@browser.button(:value => /Submit for revision/i).click

true


