#If Business is already registered then add city name
def create_business_name(data)
  new_business_name = ''
  if @browser.text.include?('The Company name field must contain a unique value')
    new_business_name = data['business'] + ' of ' + data['city']
    @browser.cookies.clear
    @browser.goto 'http://www.businessdb.com/sign-up'
    @browser.text_field(:id => 'company_name').set new_business_name
    @browser.text_field(:name => 'password_again').set data['password']
    @browser.text_field(:name => 'password').set data['password']
    @browser.select_list(:name => 'country_id').select data['country']
    @browser.text_field(:name => 'email').set data['email']
    @browser.checkbox(:name=> 'agreement').set
    @browser.link(:text=>'Sign Up FREE').click
  end
end

def add_listing(data)
  sign_in data
  @browser.goto "http://www.businessdb.com/sign-up-detail"
  @browser.text_field(:name => 'name_surname').when_present.set data['full_name']
  @browser.text_field(:name => 'www').set data['website']
  @browser.textarea(:name => 'about').set data['business_description']
  @browser.textarea(:name => 'address').set data['address']
  @browser.text_field(:id => 'company_phone').set data['phone']
  @browser.text_field(:id => 'company_fax').set data['fax']
  @browser.select_list(:name => 'city_id').select data['city']
  @browser.select_list(:name => 'category_id').select data['business_category']
  @browser.select_list(:name => 'category_id_1').select data['business_category2']
  @browser.link(:text=> 'Finish').click
end

def sign_in(data)
  @browser.goto "http://www.businessdb.com/login"
  @browser.text_field(:id => 'email').set data['email']
  @browser.text_field(:id => 'password').set data['password']
  @browser.link(:id => 'login').click
end

# Main Steps
# Launch url
url = "http://social.businessdb.com/?q=#{data['businessfixed']}&c=United States of America&r=#{data['state']}"
@browser.goto(URI.escape(url))

if @browser.text.include? "Excuse me sir, but R2-D2 says something is not right here."
  add_listing(data)
else
  businesslisted = false
  @browser.ul(:class => 'social-list').lis.each do |item|
    businesslisted = true if item.span(:class => 'social-companyName').text == data['business']
  end

  if businesslisted == true
    puts "Business already listed"
  else
    add_listing(data)
  end
end