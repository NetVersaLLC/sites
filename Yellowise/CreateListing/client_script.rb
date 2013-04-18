@browser.goto( 'http://xml.localxml.com/index.php/login' )
sign_in( data )

if @browser.link( :text => 'Add New Business').exists?
	@browser.link( :text => 'Add New Business').click
end

@browser.text_field( :id => 'common_name' ).set data[ 'business' ]
@browser.select_list( :id => 'year_started' ).select data[ 'yearfounded' ]
@browser.text_field( :id => 'address1' ).set data[ 'address' ]
@browser.text_field( :id => 'address2' ).set data[ 'address2' ]
@browser.text_field( :id => 'city' ).set data[ 'city' ]
@browser.select_list( :id => 'state' ).select data[ 'statename' ]
@browser.text_field( :id => 'zipcode' ).set data[ 'zip' ]
@browser.text_field( :id => 'zipcode3' ).set data[ 'zipcode3' ]

@browser.text_field( :id => 'telephone' ).set data[ 'phone' ]
@browser.text_field( :id => 'telephone2' ).set data[ 'altphone' ]
@browser.text_field( :id => 'toll_free_number' ).set data[ 'tollfree' ]
@browser.text_field( :id => 'fax' ).set data[ 'fax' ]
@browser.text_field( :id => 'url' ).set data[ 'website' ]

@browser.button( :text => /Continue/i).click

@browser.text_field( :id => 'description').set data['description']
@browser.select_list( :name => 'category_id').select data['category']
@browser.text_field( :id => 'keywords').set data[ 'keywords' ]

if data['licensed'] == true
	@browser.checkbox( :name => 'licensed' ).click
end

if data['insured'] == true
	@browser.checkbox( :name => 'insured' ).click
end

if data['bbb'] == true
	@browser.checkbox( :name => 'bbb' ).click
end

@browser.button( :text => /Continue/i).click


if @browser.text.include? "Your business information has been submitted."
	puts( "Business has been submitted" )	
true
end
