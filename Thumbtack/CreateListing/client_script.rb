sign_in(data)
@browser.goto("http://www.thumbtack.com/welcome?continue=true")

@browser.text_field(:name => 'sav_business_name').when_present.set data['business']
@browser.text_field(:name => 'phone_number').set data['phone']
@browser.text_field(:name => 'website').set data['website']

data['descriptionfixed'] = data['description']
data['descriptionfixed'] = "#{data['descriptionfixed']}\n#{data['description']}" while data['descriptionfixed'].length < 200

@browser.textarea(:name => 'sav_description').set data['descriptionfixed']
@browser.text_field(:name => 'sav_title').set data['title']

@browser.select_list(:name => 'address_id').select "Enter New Address Below"
@browser.text_field(:name => 'usa_address1').set data['address']

@browser.text_field(:name => 'usa_zip_code_id').set data['zip']
@browser.checkbox(:value => 'toprovider').set

@browser.link(:text => /List my services/).click

# Check for Error
if @browser.div(:class,'form-error').visible?
  throw "Validation Fails : #{@browser.div(:class,'form-error').text}"
end
sleep 2
Watir::Wait.until { @browser.text.include? "Connect Your Facebook Account" }
@browser.link(:text => /Skip this step/).click
@browser.link(:text => /Skip this step/).click

@browser.goto("http://www.thumbtack.com/profile/dashboard")
puts 'ping'
sleep 2
Watir::Wait.until { @browser.text.include? data['title'] } 
true