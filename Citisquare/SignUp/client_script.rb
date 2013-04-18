  def sign_up(data)
	  @browser.link(:text => 'Sign Up Now').click
	  @browser.text_field(:name => 'name').set data[ 'email' ]
	  @browser.text_field(:name => 'mail').set data[ 'email' ] 
	  @browser.text_field(:name => 'conf_mail').set data[ 'email' ] 
	  @browser.text_field(:name => 'pass[pass1]').set data[ 'password' ] 
	  @browser.text_field(:name => 'pass[pass2]').set data[ 'password' ] 
	  @browser.text_field(:name => 'first_name').set data[ 'first_name' ] 
	  @browser.text_field(:name => 'last_name').set data[ 'last_name' ] 
	  @browser.text_field(:name => 'zip').set data[ 'zip' ] 
	  @browser.button(:value => 'Register').click
	  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Citisquare'
  end	
  
  def matching_result(data)
	  my_list = @browser.div(:id,'addBusinessResults').ul(:index, 0)
	  #~ sleep(3)
	  @browser.wait_until { @browser.div(:class => 'message general').exist? }
	  if my_list.exist?
		  my_list.lis.each do |li|
			  if li.text.include?(data[ 'business' ])
				  @matching_result = true
				  my_list.li(:text,/#{data[ 'business' ]}/).link(:index,0).click
				  break
			  end
		  end
	  end
	  return @matching_result
  end
  
  def login(data)
	  @browser.text_field(:name => 'name').set data[ 'email' ] 
	  @browser.text_field(:name => 'pass').set data[ 'password' ] 
	  @browser.button(:value => 'Log In').click
	  @unknown_username = @browser.div(:class => 'messages error')
	  @unknown_username_msg = 'Sorry, unrecognized username or password'

	  #check for validation error
	  if @unknown_username.exist? && @unknown_username.text.include?(@unknown_username_msg)
		  puts "User name doesn't existing. Creating a new one"
		  sign_up(data)	
	  else
		  puts "User name is valid"
	  end
  end
  
  def claim_business(data)
	  @browser.link(:href => /free/).click
	  login(data)
	  @browser.checkbox(:name => 'termsChoice').set
	  @browser.button(:value => 'Upgrade Business').click
	  @confirmation = @browser.div(:id => 'landingWelcome')
	  @confirmation_msg = 'Welcome to your business dashboard'
	  
	  #Check for successful registration
	  if @confirmation.exist? && @confirmation.text.include?(@confirmation_msg)
		puts "Business successfully registered"
	  end
  end

  
# Main Script start from here
# Launch url
@url = 'http://my.citysquares.com/search'
  @browser.goto(@url)

  @browser.text_field(:name => 'b_standardname').set data[ 'business' ] 
  @browser.text_field(:name => 'b_zip').set data[ 'zip' ] 
  @browser.button(:value => 'Find My Business').click
  sleep(3)
  if matching_result(data)
	  puts "Claiming existing business listing"
	  claim_business(data)
  else  
	  puts "Adding New business listing"
	  @browser.link(:text => 'add it here!').when_present.click
	  @browser.link(:href => /free/).click
	  login(data)
	  @browser.text_field(:name => 'standardname').set data[ 'business' ] 
	  @browser.text_field(:name => 'address').set data[ 'address' ] 
	  @browser.text_field(:name => 'cityname').set data[ 'city' ]
	  @browser.select_list(:name => 'state').select data[ 'state' ]
	  @browser.text_field(:name => 'zip').set data[ 'zip' ] 
	  @browser.text_field(:name => 'areacode').set data[ 'phone_area' ]
	  @browser.text_field(:name => 'exchange').set data[ 'phone_prefix' ]
	  @browser.text_field(:name => 'phonenumber').set data[ 'phone_suffix' ]
	  @browser.text_field(:name => 'specials').set data[ 'specials' ]
	  @browser.select_list(:name => 'top_cat').select data[ 'category' ]
	  #@browser.wait_until { @browser.select_list(:name => 'inet_cat').option(:text => "#{data[ 'sub_category']}").exist? }
	  sleep(3)
	  @browser.select_list(:name => 'inet_cat').select data[ 'sub_category' ]
	  @browser.checkbox(:name => 'termsChoice').click
	  @browser.button(:value => 'Add Business').click
	  @confirmation = @browser.div(:id => 'landingWelcome')
	  @confirmation_msg = "Welcome to your business dashboard #{data[ 'first_name']}"
	  
	  #Check for successful registration
	  if @confirmation.exist? && @confirmation.text.include?(@confirmation_msg)
		puts "Business successfully registered"
	  end
  end

true
