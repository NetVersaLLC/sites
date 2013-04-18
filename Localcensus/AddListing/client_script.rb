@browser.goto( 'http://www.localcensus.com/add_business.php' )
puts(data[ 'category' ])

@browser.select_list( :name => 'business_category' ).select data[ 'category' ]
@browser.button( :value => 'Next').click

@browser.select_list( :name => 'state' ).select data[ 'state' ].upcase
@browser.button( :value => 'Next').click

@browser.select_list( :name => 'city' ).select data[ 'city' ]
@browser.button( :value => 'Next').click

@browser.text_field( :name => 'company_name').set data[ 'business' ]
@browser.text_field( :name => 'address_1').set data[ 'address' ]
@browser.text_field( :name => 'address_2').set data[ 'address2' ]
@browser.text_field( :name => 'zip').set data[ 'zip' ]
@browser.text_field( :name => 'phone').set data[ 'phone' ]
@browser.text_field( :name => 'fax').set data[ 'fax' ]
@browser.text_field( :name => 'email').set data[ 'email' ]
@browser.text_field( :name => 'website_url').set data[ 'website' ]
@browser.text_field( :name => 'hours_operation').set data[ 'hours' ]
@browser.text_field( :name => 'description').set data[ 'description' ]
@browser.radio( :name => 'agree_terms').click

@browser.button( :name => 'submit').click

if @browser.text.include? "Your business has been submitted!"
	puts("business submitted")
	true
end


