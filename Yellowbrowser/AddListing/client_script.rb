@browser.goto( 'http://yellowbrowser.com/add_business.php' )

@browser.text_field( :name => 'visitor').set data[ 'fullname' ]
@browser.text_field( :name => 'visitor').fire_event('onBlur')
@browser.text_field( :name => 'visitormail').set data[ 'email' ]
@browser.text_field( :name => 'visitormail').fire_event('onBlur')
@browser.text_field( :name => 'phone').set data[ 'phone' ]
@browser.text_field( :name => 'phone').fire_event('onBlur')
@browser.text_field( :name => 'fax').set data[ 'fax' ]
@browser.text_field( :name => 'fax').fire_event('onBlur')
@browser.text_field( :name => 'business').set data[ 'business' ]
@browser.text_field( :name => 'business').fire_event('onBlur')
@browser.text_field( :name => 'address').set data[ 'addressComb' ]
@browser.text_field( :name => 'address').fire_event('onBlur')
@browser.text_field( :name => 'city').set data[ 'city' ]
@browser.text_field( :name => 'city').fire_event('onBlur')
@browser.text_field( :name => 'state').set data[ 'state' ]
@browser.text_field( :name => 'state').fire_event('onBlur')
@browser.text_field( :name => 'zip').set data[ 'zip' ]
@browser.text_field( :name => 'zip').fire_event('onBlur')
@browser.text_field( :name => 'keyword').set data[ 'category' ]
@browser.text_field( :name => 'keyword').fire_event('onBlur')
@browser.text_field( :name => 'url').set data[ 'website' ]
@browser.text_field( :name => 'url').fire_event('onBlur')
@browser.text_field( :name => 'notes').set data[ 'description' ]
@browser.text_field( :name => 'notes').fire_event('onBlur')
@browser.select_list( :name => 'attn').select "New Listing Request"
@browser.select_list( :name => 'attn').fire_event('onBlur')

enter_captcha( data )

if @browser.text.include? "Your Listing Update Request has been received successfully..."
true
end
