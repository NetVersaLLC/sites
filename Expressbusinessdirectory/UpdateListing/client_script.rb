@browser.goto( 'http://www.expressbusinessdirectory.com/login.aspx' )
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtEmail').set data['email']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdLogin').click

30.times { break if (begin @browser.link( :text => "#{data[ 'business' ]}").present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
@browser.link( :text => "#{data[ 'business' ]}").click

30.times { break if (begin @browser.link(:id => 'ctl00_hypEditBusiness').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

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
lkey = data ['city'] + ", " + data ['state'] + ", " + data ['country']
@browser.textarea( :name => 'ctl00$ContentPlaceHolder1$txtLocationKeywords').set lkey

@browser.link(:id => 'ctl00_ContentPlaceHolder1_cmdSave').click

30.times{ break if @browser.status == "Done"; sleep 1}

true


