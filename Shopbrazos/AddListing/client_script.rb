@browser.goto('http://bryan.shopbrazos.com/add/business/')

@browser.text_field( :name => 'frmFirstName').set data['fname']
@browser.text_field( :name => 'frmLastName').set data['lname']
@browser.text_field( :name => 'frmFullAddress').set data['address']

@browser.text_field( :name => 'frmCity').set data['city']
@browser.text_field( :name => 'frmState').set data['state']
@browser.text_field( :name => 'frmZip').set data['zip']
@browser.text_field( :name => 'frmPhone1').set data['areacode']
@browser.text_field( :name => 'frmPhone2').set data['exchange']
@browser.text_field( :name => 'frmPhone3').set data['last4']
@browser.text_field( :name => 'frmEmailAddress').set data['email']

@browser.button(:name => 'submit').click

@browser.text_field( :name => 'frmBusinessName').when_present.set data['business']
@browser.text_field( :name => 'frmWebSite').set data[ 'website' ]

enter_captcha( data )

if @browser.text.include? "Thank you for submitting your business, we may contact you shortly for further details."

	true

end

