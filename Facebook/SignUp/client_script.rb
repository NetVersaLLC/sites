def create_page(data)
  @browser.link(:text => 'Create a Page').click
  @browser.div(:text => 'Local Business or Place').when_present.click
  @browser.select_list(:id=> 'category').select data[ 'category' ]
  @browser.text_field(:name => 'page_name').set data[ 'business' ]
  @browser.text_field(:name => 'address').set data[ 'address' ]
  @browser.text_field(:name => 'city').set data['location'] 
  @browser.text_field(:name => 'city').send_keys :down
  @browser.text_field(:name => 'city').send_keys :enter
  if @browser.span(:text => data['location'] ).exist?
    @browser.span(:text => data['location'] ).click
  end
  @browser.text_field(:name => 'zip').set data[ 'zip' ]
  @browser.text_field(:name => 'phone').set data[ 'phone' ] 
  @browser.checkbox(:name => 'official_check').set
  @browser.button(:value => 'Get Started').click
  #Verify
  if not @browser.link(:text=> 'Create a new business account').exist?
    puts "Throwing Error..#{@browser.div(:id =>'create_error').text}"
  end
  
end

def sign_up(data)
  @browser.link(:text=> 'Create a new business account').when_present.click
  @browser.text_field(:id =>'alogin_reg_email').set data['email']
  @browser.text_field(:id =>'reg_passwd__').set data['password']
  @browser.select_list(:id =>'birthday_month').select data['birth_month']
  @browser.select_list(:id =>'birthday_day').select data['birth_day']
  @browser.select_list(:id =>'birthday_year').select data['birth_year']
  @browser.checkbox(:id =>'terms').set
  retry_captcha(data)
  
  if @browser.text.include?('Confirm Your Email Address')
    puts "Initial Registration is successful"
    else
    puts "Inital Registration is Unsuccessful"
  end
end

#Main Steps
create_page(data)
sign_up(data)

if @chained
  self.start("Facebook/Verify")
end
true
