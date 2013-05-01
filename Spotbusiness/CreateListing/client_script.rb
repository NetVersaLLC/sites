def add_listing(data)
  @browser.goto('http://spotabusiness.com/Create-an-account.html')
  @browser.text_field(:name => 'name').set data[ 'full_name' ]
  @browser.text_field(:id => 'username').set data[ 'email' ]
  @browser.text_field(:name => 'password__verify').set data[ 'password' ]
  @browser.text_field(:name => 'password').set data[ 'password' ]
  @browser.text_field(:name => 'company').set data[ 'business' ]
  @browser.text_field(:name => 'address').set data[ 'address' ]
  @browser.text_field(:name => 'city').set data[ 'city' ]
  @browser.select_list(:name => 'cb_statelist').select data[ 'state' ]
  @browser.text_field(:name => 'zipcode').set data[ 'zip' ]
  @browser.text_field(:name => 'cb_phone').set data[ 'phone' ]
  @browser.text_field(:name => 'email').set data[ 'email' ]
  @browser.select_list(:name => 'cb_businesscategory').select data[ 'business_category' ]
  @browser.select_list(:name=> 'cb_profilechoose').select data['profile_type']
  #@browser.test_field(:name=> 'twittername').set data['twitter_account']
  @browser.checkbox(:name => 'acceptedterms').set

#Enter Decrypted captcha string here
enter_captcha
@confirmation_msg = 'An email with further instructions on how to complete your registration has been sent to the email address you provided.'
sleep 2
Watir::Wait.until { @browser.text.include? @confirmation_msg }
  

  if @browser.text.include?(@confirmation_msg)
    puts "Initial registration Successful"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ], 'account[password]' => data['password'], 'model' => 'Spotbusiness'

    if @chained 
      self.start('Spotbusiness/Verify')
    end
    true

  else
    throw "Initial registration not successful"
  end
end

#main steps
if add_listing(data)
  true
end
