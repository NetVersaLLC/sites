# sign_in(data)
@browser.cookies.clear
@browser.goto("https://www.thumbtack.com/welcome")

@browser.text_field(:name => 'sav_business_name').when_present.set data['business']
@browser.text_field(:name => 'phone_number').set data['phone']
@browser.text_field(:name => 'website').set data['website']

data['descriptionfixed'] = data['description']
data['descriptionfixed'] = "#{data['descriptionfixed']}\n#{data['description']}" while data['descriptionfixed'].length < 200

@browser.textarea(:name => 'sav_description').set data['descriptionfixed']
@browser.text_field(:name => 'sav_title').set data['title']

@browser.text_field(:name => 'usa_address1').set data['address']

@browser.text_field(:name => 'usa_zip_code_id').set data['zip']
@browser.checkbox(:value => 'tocustomer').set

@browser.text_field(:id => 'usr_first_name').set data['first_name']
@browser.text_field(:id => 'usr_last_name').set data['last_name']
@browser.text_field(:id => 'usr_email').set data['email']

@browser.link(:text => /List my services/).click
@browser.text_field(:id => 'password').when_present.set data['password']
@browser.link(:text => /Sign in and continue »/).click

# Check for Error
if @browser.div(:class,'form-error').visible?
  throw "Validation Fails : #{@browser.div(:class,'form-error').text}"
end

Watir::Wait.until { @browser.text.include? "Connect your Facebook account" }
@browser.link(:text => /Skip this step/).click
@browser.link(:text => /Skip this step/).click

@browser.goto("http://www.thumbtack.com/profile/dashboard")

Watir::Wait.until { @browser.text.include? "What's new with your services?" } 
true