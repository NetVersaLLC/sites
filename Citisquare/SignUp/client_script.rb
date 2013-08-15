def sign_up(data)
  @browser.link(:text => 'Sign Up Now').click
  sleep 2
  @browser.text_field(:name => 'name').when_present.set data['username']
  @browser.text_field(:name => 'mail').set data['email'] 
  @browser.text_field(:name => 'conf_mail').set data['email'] 
  @browser.text_field(:name => 'pass[pass1]').set data['password'] 
  @browser.text_field(:name => 'pass[pass2]').set data['password'] 
  @browser.text_field(:name => 'first_name').set data['first_name'] 
  @browser.text_field(:name => 'last_name').set data['last_name'] 
  @browser.text_field(:name => 'zip').set data['zip'] 
  @browser.button(:value => 'Register').click
  sleep 2
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Citisquare'
end  
  
# Main Script start from here
# Launch url
url = 'http://my.citysquares.com/search'
@browser.goto url

30.times{ break if @browser.status == "Done"; sleep 1}

@browser.text_field(:name => 'b_standardname').set data['business'] 
@browser.text_field(:name => 'b_zip').set data['zip'] 
@browser.button(:value => 'Find My Business').click


sleep 3
if matching_result data
  puts "Claiming existing business listing"
  claim_business data
else  
  puts "Adding New business listing"
  sleep 2
  @browser.link(:text => 'add it here!').when_present.click
  @browser.link(:href => /free/).click

  sleep 2
  login data 

  sleep 2
	fill_listing_form data

  @browser.button(:value => 'Add Business').click
  sleep 2
  @confirmation = @browser.div(:id => 'landingWelcome')
  @confirmation_msg = "Welcome to your business dashboard #{data['first_name']}"
  
30.times{ break if @browser.status == "Done"; sleep 1}

  #Check for successful registration
  if @confirmation.exist? && @confirmation.text.include?(@confirmation_msg)
      puts "Business successfully registered"
      self.start("Citisquare/ClaimListing", 4320)
  end
true
end