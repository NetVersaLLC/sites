def login(data)
  $login_success = false
  @browser.text_field( :id => 'user_id').set data[ 'username' ]
  @browser.text_field( :id => 'pass').set data[ 'password' ]
  @browser.button( :id => 'login').click
  @browser.wait()
  if @browser.link(:text => 'Logout').exist?
	$login_success = true
  end
  return $login_success
end


def Add_listing(data)
  # Start page
  if @browser.image(:src => /tx=Start/).exists?
   @browser.image(:src => /tx=Start/).click
  end
  
  if @browser.image(:src => /tx=Continue/).exists?
   @browser.image(:src => /tx=Continue/).click
  end
   #Step -I Company
  @browser.text_field( :id => 'company_descr').when_present.set data[ 'description' ]
  @browser.text_field( :id => 'company_site').set data[ 'website' ]
  @browser.text_field( :id => 'salutation').set data[ 'salutation' ]
  @browser.text_field( :id => 'position').set data[ 'position' ]
  @browser.text_field( :id => 'phone_num_area').set data['areacode']
  @browser.text_field( :id => 'phone_num').set data['phone']
  @browser.button( :id => /updatecompany/i).click
  # Step - II Location
  @browser.text_field( :id => 'city').when_present.set data[ 'city' ]
  @browser.select_list( :id => 'stateprov').select data['state']
  @browser.text_field( :id => 'postalcode').set data[ 'zip' ]
  @browser.text_field( :id => 'location_name').set data[ 'location_name' ]
  @browser.text_field( :id => 'location_descr').set data[ 'description' ]
  #TODO add dynamic Location Types
  @browser.checkbox( :id => 'type_retail_b2c').click
  @browser.button( :name => /forwardtocontacts/i).click
  @browser.text_field( :id => 'row1a' ).when_present.set data[ 'contact_description' ]
  @browser.text_field( :id => 'row1b' ).set data[ 'nameFNL' ]
  @browser.text_field( :id => 'row1c').set data[ 'email' ]
  @browser.text_field( :name => 'ConPhone1_area' ).set data[ 'areacode' ]
  @browser.text_field( :name => 'ConPhone1_num' ).set data[ 'phone' ]
  @browser.text_field( :id => 'link_row1a' ).set data[ 'linkdescription' ]
  @browser.text_field( :id => 'link_row1b' ).set data[ 'website' ]
  @browser.button( :name => /save/i).click
  if @browser.image(:src => /tx=Next/).exists?
   @browser.image(:src => /tx=Next/).click
  end

    # Step -III Brands
  @browser.link(:title => /Cancel and return to the main brands page/i).when_present.click
  if @browser.button(:title => 'Complete the registration').exist?
	@browser.button(:title => 'Complete the registration').when_present.click
	puts "Business Listing is successfull"
  end
end

#Main Steps
url = 'http://www.freebusinessdirectory.com/login.php?'
@browser.goto(url)
if login(data)
  puts "Login is successful"
  Add_listing(data)
else
  puts "Login failed"
end

true


