@browser.goto( 'http://www.askyp.com/contact.php' )
@browser.text_field( :name, 'FirstName').set data[ 'firstname' ]
@browser.text_field( :name, 'LastName').set data[ 'lastname' ]
@browser.text_field( :name, 'Uemail').set data[ 'email' ]
@browser.text_field( :name, 'Phone').set data[ 'phone' ]
@browser.select_list( :name, 'AUD').select data[ 'add' ]
@browser.text_field( :name, 'URL').set data[ 'website' ]
@browser.text_field( :name, 'Message').set data[ 'message' ]

enter_captcha( data )

true
