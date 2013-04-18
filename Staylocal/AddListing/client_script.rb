sign_in(data)
sleep(2)
@browser.goto("https://www.staylocal.org/node/add/business-listing")

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
@browser.button(:value => 'Save').click
  
Watir::Wait.until{ @browser.div(:class => 'messages error').exists? or @browser.text.include? "Initial draft created, pending publication"}
 sleep(100)
  
  if @browser.text.include? "A validation e-mail has been sent to your e-mail address"
    true
  else
    throw "Adding business failed"
  end


