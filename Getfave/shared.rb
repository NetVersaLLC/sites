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
  @browser.text_field(:id => 'business_location').set data['address']
  @browser.text_field(:id => 'business_phone_number').set data['phone']
  @browser.text_field(:id => 'business_tags').set data['keywords']
  @browser.link(:text => 'Manage More Attributes').click
  @browser.text_field(:id => 'business_established').set data['year']
  @browser.text_field(:id => 'business_tagline').set data['tagline']
  @browser.text_field(:id => 'business_description').set data['discription']
  @browser.text_field(:id => 'business_url').set data['url']
  @browser.text_field(:id => 'business_email').set data['business_email']
  @browser.text_field(:id => 'business_hours').set data['business_hours']
  @browser.button(:value => 'Publish Changes').click

  raise Exception, @browser.element(:class => 'error').text if @browser.element(:class => 'error').exist?
end