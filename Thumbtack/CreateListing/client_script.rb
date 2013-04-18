sign_in(data)
@browser.goto("https://www.thumbtack.com/welcome")

@browser.text_field(:name => 'sav_business_name').when_present.set data ['business']
  @browser.text_field(:name => 'phone_number').set data ['phone']
  @browser.text_field(:name => 'website').set data ['website']
  @browser.text_field(:name => 'sav_description').set data ['description']
  @browser.text_field(:name => 'sav_title').set data ['title']
  
  

    @browser.text_field(:name => 'usa_address1').set data ['address']
  
  @browser.text_field(:name => 'usa_zip_code_id').set data ['zip']
  @browser.checkbox(:value => 'tocustomer').set
  @browser.link(:text,/List my services/).click
  # Check for Error
  if @browser.div(:class,'form-error').visible?
    throw("Validation Fails : #{@browser.div(:class,'form-error').text}")
  end

@browser.goto("http://www.thumbtack.com/profile/dashboard")

Watir::Wait.until { @browser.text.include? "What's new with your services?" } 

true