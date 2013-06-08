# Method for Sign Up

def sign_up(data)
  @browser.goto('http://uscity.net/register')
  @browser.text_field(:name => 'email').when_present.set data[ 'email' ]
  @browser.text_field(:name => 'password').set data[ 'password' ]
  @browser.text_field(:name => 'name').set data[ 'full_name' ]
  @browser.select_list(:name => 'security_ques').when_present.select data['security_question']
  @browser.text_field(:name => 'security_ans').set data[ 'security_answer' ]
  @browser.text_field(:name => 'business_name').set data[ 'business' ]
  @browser.text_field(:name => 'web_url').set data[ 'website' ]
  @browser.text_field(:name => 'email').set data[ 'email' ]
  @browser.text_field(:name => 'business_address').set data[ 'address' ]
  @browser.text_field(:name => 'town').set data[ 'city' ]
  @browser.select_list(:name => 'state_linkId').select data['state']
  @browser.text_field(:name => 'zip').set data[ 'zip' ]
  @browser.text_field(:name => 'daytime_phone').set data[ 'phone' ]
  @browser.text_field(:name => 'short_description').set data[ 'business_description' ]
  @browser.text_field(:name => 'category_name[]').set data[ 'category' ]
  @browser.text_field(:name => 'Fax_Number').set data[ 'fax' ]
  @browser.file_field(:id => 'Logo_URL').set business['logo']

  #Enter Decrypted captcha string here
  enter_captcha(data)

  @confirmation_msg = 'Verification link has been sent to your email.'
  sleep(3)
  Watir::Wait.until{ @browser.text.include? @confirmation_msg }

  if @browser.text.include?(@confirmation_msg)
    puts "Initial registration Successful"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ], 'account[password]' => data['password'], 'account[secret_answer]' => data['security_answer'], 'model' => 'Uscity'
    true
  else
    throw "Initial registration not successful"
  end
end

#Main Steps
sign_up(data)

if @chained
  self.start("Uscity/Verify")
end
