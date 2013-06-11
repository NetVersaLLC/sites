def sign_in(data)
  @browser.link(:text => 'Log In/Join').click
  @browser.text_field(:id => 'session_email').set data['email']
  @browser.text_field(:id => 'session_password').set data['password']
  @browser.button(:value => 'Log In').click
  # @browser.button(:xpath => '//*[@id="signin-container"]/form/input[3]').click
end

def change_location(data)
  @browser.link(:id => 'change-location').when_present.click
  @browser.text_field(:id => 'g-text-field').set data['city'] + ", " + data['state']

  sleep 3

  @browser.text_field(:id => 'g-text-field').send_keys :enter
  @browser.send_keys :enter
end

def fill_business(data)
  @browser.text_field(:id => 'business_name').set data['business']
  #puts('Debug: Name Set')
  @browser.text_field(:id => 'business_location').set data['address']
  #puts('Debug: Address Set')
  @browser.text_field(:id => 'business_phone_number').set data['phone']
  #puts('Debug: Phone Set')
  @browser.text_field(:id => 'business_tags').set data['keywords']
  #puts('Debug: Tags Set')
  #Some brief Javascript as Ruby fails
  @browser.execute_script("
  jQuery('a#edit-more.result-style').trigger('click') 
  ")
  #@browser.link(:id => 'edit-more').click
  sleep(1)
  #puts('Debug: More Attributes Clicked')

  Watir::Wait.until { @browser.text_field(:id => 'business_established').exists? }

  @browser.text_field(:id => 'business_established').set data['year']
  #puts('Debug: Year Set')
  @browser.text_field(:id => 'business_tagline').set data['tagline']
  #puts('Debug: Tagline Set')
  @browser.text_field(:id => 'business_description').set data['discription']
  #puts('Debug: Description Set')
  @browser.text_field(:id => 'business_url').set data['url']
  #puts('Debug: Website Set')
  @browser.text_field(:id => 'business_email').set data['business_email']
  #puts('Debug: Email Set')
  @browser.text_field(:id => 'business_hours').set data['business_hours']
  #puts('Debug: Hours Set')
  @browser.button(:value => 'Publish Changes').click
  #puts('Debug: Changes Published')

  raise Exception, @browser.element(:class => 'error').text if @browser.element(:class => 'error').exist?
end