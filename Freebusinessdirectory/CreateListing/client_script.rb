@browser.goto( 'http://www.freebusinessdirectory.com/login.php?' )
@browser.text_field( :id => 'user_id').set data[ 'username' ]
@browser.text_field( :id => 'pass').set data[ 'password' ]
@browser.button( :id => 'login').click
sleep(5)

#if @browser.image(:src => 'get_button_image.php?tx=Continue%20Registration').exists?
#  @browser.image(:src => 'get_button_image.php?tx=Continue%20Registration').click
#end

company = @browser.url.split("=")[1]
puts(company)
#@browser.image( :src => /get_button_image.php?tx=Start%20%3E%3E/i).click
#@browser.link( :href => '

@browser.goto("http://www.freebusinessdirectory.com/signup_commodify.php?co="+company)

@browser.text_field( :id => 'company_descr').set data[ 'description' ]
@browser.text_field( :id => 'company_site').set data[ 'website' ]
@browser.text_field( :id => 'salutation').set data[ 'salutation' ]
@browser.text_field( :id => 'middlename').set data[ 'middlename' ]
@browser.text_field( :id => 'position').set data[ 'position' ]
@browser.text_field( :id => 'phone_num_area').set data['areacode']
@browser.text_field( :id => 'phone_num').set data['phone']

@browser.button( :id => /updatecompany/i).click

@browser.text_field( :id => 'city').set data[ 'city' ]
@browser.select_list( :id => 'stateprov').select data['state']
@browser.text_field( :id => 'postalcode').set data[ 'zip' ]
@browser.text_field( :id => 'location_name').set data[ 'location_name' ]
@browser.text_field( :id => 'location_descr').set data[ 'description' ]

#TODO add dynamic Location Types
@browser.checkbox( :id => 'type_retail_b2c').click

@browser.button( :name => /forwardtocontacts/i).click

@browser.text_field( :id => 'row1a' ).set data[ 'contact_description' ]
@browser.text_field( :id => 'row1b' ).set data[ 'nameFNL' ]
@browser.text_field( :id => 'row1c').set data[ 'email' ]
@browser.text_field( :name => 'ConPhone1_area' ).set data[ 'areacode' ]
@browser.text_field( :name => 'ConPhone1_num' ).set data[ 'phone' ]

@browser.text_field( :id => 'link_row1a' ).set data[ 'linkdescription' ]
@browser.text_field( :id => 'link_row1b' ).set data[ 'website' ]

@browser.button( :name => /save/i).click
@browser.td( :text => 'Select brands for your company').wait_until_present

@browser.link( :title => /Cancel and return to the main brands page/i).click

@browser.button(:title => 'Complete the registration').click


true




