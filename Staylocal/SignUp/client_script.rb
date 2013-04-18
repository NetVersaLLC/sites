@url = 'https://www.staylocal.org/node/add/business-listing'
@browser.goto(@url)


  @browser.text_field(:name => 'name').set data[ 'username' ]
  @browser.text_field(:name => 'mail').set data[ 'email' ]
  @browser.text_field(:name => 'pass[pass1]').set data[ 'password' ]
  @browser.text_field(:name => 'pass[pass2]').set data[ 'password' ]
  @browser.text_field(:name => 'title').set data[ 'business' ]
  @browser.text_field(:name => /street/).set data[ 'address' ]
  @browser.text_field(:name => /city/).set data[ 'city' ]
  @browser.text_field(:id => /province/).set data[ 'state' ]
  @browser.text_field(:id => /province/).send_keys :tab

  @browser.text_field(:name => /postal_code/).set data[ 'zip' ]
  @browser.text_field(:name => /phone/).set data[ 'phone' ]
  @browser.text_field(:name => /business_owner/).set data[ 'full_name' ]
  @browser.text_field(:name => /business_owner_email/).set data[ 'email' ]
  @browser.text_field(:name => /description/).set data[ 'business_description' ]
  @browser.text_field(:name => /keywords/).set data[ 'keywords' ]
  @browser.select_list(:id => /edit-taxonomy-4/).option(:text => /#{data[ 'category' ]}/).click
  @browser.select_list(:id => /edit-taxonomy-2/).select data[ 'parish' ]

  
  #Enter Captcha Code
  # @browser.text_field(:name => 'recaptcha_response_field').set captcha_textcha
  #@browser.button(:value => 'Save').click
  
enter_captcha


Watir::Wait.until{ @browser.div(:class => 'messages error').exists? or @browser.text.include? "A validation e-mail has been sent to your e-mail address"}
 
  
  if @browser.text.include? "A validation e-mail has been sent to your e-mail address"
    puts "Initial Business registration is successful"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'username' ], 'model' => 'Staylocal'
    
    if @chained
      self.start("Staylocal/Verify")
    end

    true
  else
    throw "Initial Business registration is Unsuccessful"
  end


