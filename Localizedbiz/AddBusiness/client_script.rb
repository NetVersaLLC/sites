sign_in(data)
@browser.goto('http://www.localizedbiz.com/add.php')

@browser.text_field(:id => 'location_name').when_present.set data['business']
@browser.text_field(:name => 'address1').set data['address']
@browser.text_field(:name => 'city').set data['city']
@browser.select_list(:name => 'state').select data['state']
@browser.text_field(:name => 'zip1').set data['zip']
@browser.text_field(:name => 'areacode').set data['areacode']
@browser.text_field(:name => 'exchange').set data['exchange']
@browser.text_field(:name => 'phone').set data['last4']
@browser.text_field(:name => 'email').set data['email']

@browser.text_field(:name => 'url').set data['website']
sleep(50)
@browser.select_list(:name => 'biz_cat1').select data['category1']
#Wait for sub category to load
 
30.times{break if (begin @browser.select_list(:name => 'biz_cat2').options.length > 1 rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1}
 
@browser.select_list(:name => 'biz_cat2').select data['category2']
@browser.textarea(:name => 'keywords').set data['keywords']
@browser.text_field(:name => 'tagline').set data['tagline']
@browser.textarea(:name => 'description').set data['description']

unless self.logo.nil? 
  @browser.file_field(:name => 'new_image').set self.logo
else
  @browser.file_field(:name => 'new_image').set self.images.first unless self.images.nil?
end

@browser.button(:name => 'submit').click

30.times{break if (begin @browser.text.include?("Listing Successfully Added")  rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1} 

true
