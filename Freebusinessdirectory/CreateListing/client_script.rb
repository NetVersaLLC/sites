@browser = Watir::Browser.new
at_exit do 
  @browser.close unless @browser.nil?
end

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

def update_company_data(data)
 @browser.text_field( :id => 'company_descr').when_present.set data[ 'description' ]
  # puts "efgh"
  @browser.text_field( :id => 'company_site').set data[ 'website' ]
  @browser.text_field( :id => 'salutation').set data[ 'salutation' ]
  @browser.text_field( :id => 'position').set data[ 'position' ]
  @browser.text_field( :id => 'phone_num_area').set data['areacode']
  @browser.text_field( :id => 'phone_num').set data['phone']
  @browser.button( :id => /updatecompany/i).click
end
def update_location_data(data)
  @browser.text_field( :id => 'city').when_present.set data[ 'city' ]
  @browser.select_list( :id => 'stateprov').select data['state']
  @browser.text_field( :id => 'postalcode').set data[ 'zip' ]
  @browser.text_field( :id => 'location_name').set data[ 'location_name' ]
  @browser.text_field( :id => 'location_descr').set data[ 'description' ]
  #TODO add dynamic Location Types
  @browser.checkbox( :id => 'type_retail_b2c').set
  # @browser.div( :xpath => '/html/body/div/table/tbody/tr/td/table/tbody/tr[6]/td/table/tbody/tr/td[3]/div/table/tbody/tr[2]/td/table/tbody/tr[5]/td/form/div/div/table/tbody/tr/td[3]/div').click
 @browser.element(:css=>'html body div table.main_table tbody tr td table tbody tr td table tbody tr td div table tbody tr td table tbody tr td form div div table tbody tr td div input').click
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
 if @browser.text_field(:id=>'company_descr').exists?
   update_company_data(data)
  # Step - II Location
   update_location_data(data)
  if @browser.image(:src => /tx=Next/).exists?
   @browser.image(:src => /tx=Next/).click
  end

    # Step -III Brands
  @browser.link(:title => /Cancel and return to the main brands page/i).when_present.click
  if @browser.button(:title => 'Complete the registration').exist?
	@browser.button(:title => 'Complete the registration').when_present.click
	puts "Business Listing is successfull"
  end
  @browser.image(:class => "website_thumbnail").parent.href 
  
  else
    @browser.link(:xpath=>'/html/body/div/table/tbody/tr/td/table/tbody/tr[6]/td/table/tbody/tr/td[3]/div/table/tbody/tr[2]/td/table/tbody/tr[5]/td/table/tbody/tr/td/div/table/tbody/tr/td[6]/a').click

  # sleep 10
     @browser.link(:xpath=>'/html/body/div/table/tbody/tr/td/table/tbody/tr[6]/td/table/tbody/tr/td[3]/div/table/tbody/tr[2]/td/table/tbody/tr[5]/td/table/tbody/tr[2]/td/table/tbody/tr/td/div/div/table[2]/tbody/tr/td[3]/a[2]').click
  # sleep 10
     update_company_data(data)
     @browser.link(:xpath=>'/html/body/div/table/tbody/tr/td/table/tbody/tr[6]/td/table/tbody/tr/td[3]/div/table/tbody/tr[2]/td/table/tbody/tr[8]/td/table/tbody/tr[2]/td/table/tbody/tr/td/div/div/table[2]/tbody/tr[5]/td[3]/a').click
    @browser.link(:xpath=>'/html/body/div/table/tbody/tr/td/table/tbody/tr[6]/td/table/tbody/tr/td[3]/div/table/tbody/tr[2]/td/table/tbody/tr[8]/td/form/div/table/tbody/tr[2]/td[6]/div/a').click
     update_location_data(data)
     sleep 20
     @browser.image(:xpath=>'/html/body/div/table/tbody/tr/td/table/tbody/tr[6]/td/table/tbody/tr/td[3]/div/table/tbody/tr[2]/td/table/tbody/tr[8]/td/form/div/table[2]/tbody/tr[3]/td[3]/div/a/img').click
  
  # sleep 40
     @browser.element(:css=>'html body div table.main_table tbody tr td table tbody tr td table tbody tr td div table tbody tr td table tbody tr td table#tab_table tbody tr#tab_row_0 td div table tbody tr td#m1.tab_label a.tll').click
     sleep 20
     @browser.image(:class => "website_thumbnail").parent.href 
  end

end

#Main Steps
url = 'http://www.freebusinessdirectory.com/login.php?'
@browser.goto(url)
if login(data)
  listing_url = Add_listing(data)
  self.save_account("Freebusinessdirectory", {:listing_url => listing_url})
else
  puts "Login failed"
end
true


