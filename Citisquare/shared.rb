def login(data)
  @browser.text_field(:name => 'name').set data['email'] 
  @browser.text_field(:name => 'pass').set data['password'] 
  @browser.button(:value => 'Log In').click

  #check for validation error

  sleep 3
  Watir::Wait.until{ @browser.link(:text => 'My Account').exists? or @browser.text.include? 'Sorry, unrecognized username or password'}

  if @browser.text.include? 'Sorry, unrecognized username or password'
    puts "User name doesn't exist. Creating a new one"
    sign_up data
  else
    puts "User name is valid"
  end
end

def matching_result(data)
  my_list = @browser.div(:id => 'addBusinessResults').ul(:index => 0)
  #~ sleep(3)
  @browser.wait_until { @browser.div(:class => 'message general').exist? }
  if my_list.exist?
    my_list.lis.each do |li|
      if li.text.include?(data['business'])
        @matching_result = true
        my_list.li(:text => /#{data['business']}/).link(:index => 0).click
        break
      end
    end
  end
  return @matching_result
end

def fill_listing_form(data)
  @browser.text_field(:name => 'standardname').set data['business'] 
  @browser.text_field(:name => 'address').set data['address'] 
  @browser.text_field(:name => 'cityname').set data['city']
  @browser.select_list(:name => 'state').select data['state']
  @browser.text_field(:name => 'zip').set data['zip'] 
  @browser.text_field(:name => 'areacode').set data['phone_area']
  @browser.text_field(:name => 'exchange').set data['phone_prefix']
  @browser.text_field(:name => 'phonenumber').set data['phone_suffix']
  @browser.text_field(:name => 'specials').set data['specials']
  @browser.select_list(:name => 'top_cat').select data['category']
  # Watir::Wait.until { @browser.select_list(:name => 'inet_cat').option(:text => "#{data['sub_category']}").exist? }
  sleep(3)
  @browser.select_list(:name => 'inet_cat').select data['sub_category']
  @browser.checkbox(:name => 'termsChoice').click
end

def claim_business(data)
  @browser.link(:href => /free/).click
  login data
  @browser.checkbox(:name => 'termsChoice').set
  @browser.button(:value => 'Upgrade Business').click
  @confirmation = @browser.div(:id => 'landingWelcome')
  @confirmation_msg = 'Welcome to your business dashboard'
  
  #Check for successful registration
  if @confirmation.exist? && @confirmation.text.include?(@confirmation_msg)
    puts "Business successfully registered"
  end
end