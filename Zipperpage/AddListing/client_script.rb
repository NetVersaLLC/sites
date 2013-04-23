#Method for create listing  
def create_listing(data) 
  #Fill form on Step -I
  @browser.link(:text => "Advertise").click	
  @browser.text_field(:name,'get_company').set data[ 'business' ]
  @browser.text_field(:name,'get_first_name').set data[ 'first_name' ]
  @browser.text_field(:name,'get_last_name').set data[ 'last_name' ]
  @browser.select_list(:name => 'get_ref_country').select 'United States'
  @browser.text_field(:name => 'get_phone').set data[ 'phone' ]
  @browser.text_field(:name => 'get_address').set data[ 'address' ]
  @browser.text_field(:name => 'get_city').set data[ 'city' ]
  @browser.text_field(:name => 'get_zip').set data[ 'zip' ]
  @browser.text_field(:name => 'get_email').set data[ 'email' ]
  @browser.text_field(:name => 'get_main_category').set data[ 'category' ]
  @browser.text_field(:name => 'get_website').set data[ 'website' ]
  @browser.select_list(:name => 'get_ref_state').select get_state_name(data[ 'state' ])

  #Check if business get listed
  @success_msg = "Thank you for submitting your company information"
  if @browser.text.include?(@success_msg)
	  puts "Business get listed successfully"
	  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Zipperpage'
  
  end  
end
  
# Main Script start from here
# Launch url
@url = 'http://www.zipperpages.com'
@browser = Watir::Browser.new
@browser.goto(@url)
#Create Listing
create_listing(data) 
