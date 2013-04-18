def add_new_business(data)
  # First Step
  @browser.select_list(:name => 'thirdParty').select(/#{data[ 'is_owner' ]}/)
  if data[ 'is_owner'] == 'No'
    @browser.text_field(:name => 'regNameRelation').set data[ 'relation_to_business' ]
  end
  @browser.text_field(:name => 'OwnerNameFirst').set data[ 'first_name']
  @browser.text_field(:name => 'OwnerNameLast').set data[ 'last_name']
  @browser.text_field(:name => 'ContactPhone').set data[ 'phone']
  @browser.text_field(:name => 'ContactEmail').set data[ 'email']
  @browser.text_field(:name => 'ContactEmail2').set data[ 'email']
  @browser.text_field(:name => 'lName').set data[ 'business']
  @browser.text_field(:name => 'lContact').value = data[ 'fullname' ]
  @browser.text_field(:name => 'lEmail').set data[ 'email']
  @browser.text_field(:name => 'lAddress').set data[ 'address']
  @browser.text_field(:name => 'lCity').set data[ 'city']
  @browser.select_list(:name => 'lState').select data[ 'state']
  @browser.text_field(:name => 'lZip').set data[ 'zip']
  @browser.execute_script("window.open('add-your-business-cat.cfm')")
  sleep(5)
	
  #attach new window
  @browser.window(:url,/add-your-business-cat/i).use do
    @browser.text_field(:id=> "search").when_present.set data[ 'business_category']
    @browser.button(:value => 'Search').click
    @browser.link(:text => "#{data[ 'business_category' ]}").click		
  end
  @browser.text_field(:name => 'describeBiz').set data[ 'business_description'] 
  @browser.checkbox(:name => 'optin').set
  @browser.button(:value => 'Submit').click
	
 #Check for error
  if @browser.text.include?('Oops!...')
    throw "Somethign went wrong while filling basic info"
  end
	
 # Second Step
  @browser.text_field(:name => 'ServicesExtra').set data[ 'additional_services' ] 
  @browser.text_field(:name => 'ProductsExtra').set data[ 'additional_products' ] 
  @browser.text_field(:name => 'BrandsExtra').set data[ 'additional_brands' ] 
  
  # Add payment_options
  payments = data['payment_option']
  payments.each do |payment|
    @browser.checkbox(:value => card_type(payment).to_s).click
  end
  @browser.button(:value => 'Submit').click
  @success_msg = 'Congratulations, you have claimed your business and created a profile page.'
  if @browser.text.include?(@success_msg)
    puts "Initial registration is Successful"

  if @chained
    self.start("Magicyellow/Verify")
  end

true
  else
    throw "Initial registration is not Successful"
  end
end

#Main Steps
@browser.goto("http://www.magicyellow.com/add-your-business.cfm")
# Search for existing business by phone
if search_by_phone(data)
  claim_business(data)
else
  @browser.link(:text => 'Add Your Business').click
  add_new_business(data)
end