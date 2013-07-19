def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\insiderpages_captcha.png"
  obj = @browser.div(:id => 'recaptcha_image').image
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha(data)
  captcharetries = 5
  begin
    captcha_code = solve_captcha 
    @browser.checkbox(:id => 'terms_of_service').set
    @browser.text_field(:id => 'recaptcha_response_field').set captcha_code
    @browser.button(:value => 'submit').click

  rescue Exception => e
    puts(e.inspect)
    if captcharetries > 0      
      puts "Retrying in 3 seconds..."
      sleep 3
      captcharetries -= 1
      retry
    else
      throw "Job failed after trying to enter captcha 5 times."
    end
  end

  return true
end

def sign_in(data)
	@browser.goto 'http://www.insiderpages.com/session/new?header_link=true'
	@browser.text_field(:id, 'friend_session_email').set data['email']
	@browser.text_field(:id, 'friend_session_password').set data['password']
	@browser.button(:value, 'sign in').click
end

def search_business(data)
  @browser.text_field(:id => 'sphinx_search_query').set data['business']
  @browser.text_field(:id => 'sphinx_search_location').set data['near_city']
  @browser.button(:id => 'sphinx_search_submit').click
  @browser.select_list(:id => 'radius').select 'Within 1 mile'
  @browser.button(:value => 'Submit').click
end

def fill_form(data)
  count = @browser.links(:text => '×', :class => 'as-close').count
  count.times { @browser.link(:text => '×').click }

  @browser.text_field(:id => 'business_name').set data['business']
  @browser.text_field(:id => 'business_address_1').set data['address']
    
  @browser.text_field(:name => 'city').set data['city']
  Watir::Wait.until { @browser.li(:id => 'as-result-item-0',:index => 0).exist? }
  sleep(2)
  @browser.li(:text => data['city']).click

  @browser.select_list(:id => 'business_state_code').select data['state']
  @browser.text_field(:id => 'business_zip_code').set data['zip']
  @browser.text_field(:id => 'business_phone').set data['phone']
  @browser.text_field(:id => 'business_email_address').set data['business_email']
  @browser.text_field(:id => 'business_url').set data['website']

  gories = data['categories']
  gories.each do |categ| 
    if categ != ""
      @browser.text_field(:name => 'selected_categories').set categ
      sleep(5)
      Watir::Wait.until { @browser.li(:id => 'as-result-item-0',:index => 0).exist? }
      sleep(2)
      @browser.li(:text => categ).click  
    end
  end
    
  # tags = data['tags']
  # tags.each do |tag| 
  #   if tag != ""
  #     @browser.text_field(:name => 'selected_taggings').set tag

  #     Watir::Wait.until{ @browser.li(:id => 'as-result-item-0',:index => 0).exist? }
  #     sleep(2)
  #     @browser.li(:text => tag).click  
  #   end
  # end
end

def update_business(data)
  count = @browser.links(:text => '×', :class => 'as-close').count
  count.times { @browser.link(:text => '×').click }

  #Regardless of the business existing or being added, this is the last step
  #all fields are optional
  @browser.text_field(:id => 'business_name').when_present.set data['business']
  @browser.text_field(:id => 'business_url').set data['website']  
  @browser.text_field(:id => 'business_email_address').set data['business_email']

  gories = data['categories']
  gories.each do |categ| 
    if categ != ""
      @browser.text_field(:name => 'business_categorizations').set categ
      sleep(5)
      Watir::Wait.until { @browser.li(:id => 'as-result-item-0',:index => 0).exist? }
      sleep(2)
      @browser.li(:text => categ).click
    end
  end

  @browser.text_field(:id => 'business_merchant_attributes_bio').set data['business_description']
  @browser.text_field(:id => 'business_merchant_attributes_services').set data['services']
  @browser.text_field(:id => 'business_merchant_attributes_message').set data['message']

  if self.logo.nil?
    @browser.checkbox(:name => 'business[photos_attributes][0][_destroy]').set if @browser.checkbox(:name => 'business[photos_attributes][0][_destroy]').exist?
  else
    @browser.file_field(:id => 'business_photos_attributes_99_uploaded_data').value = self.logo
  end

  @browser.button(:value => 'update business').click

  Watir::Wait.until { @browser.text.include? 'Your changes were successfully saved.' }

  true
end