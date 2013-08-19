@browser.goto "meetlocalbiz.com/login"

@browser.text_field(:id => 'email').set data['username']
@browser.text_field(:id => 'password').set data['password']

sleep 1

@browser.button(:id => 'mySubmit').click

30.times { break if (begin @browser.link(:text => 'MyMLBC Portal').exists? or @browser.text.include? "My News Feed" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

if @browser.link(:text => 'MyMLBC Portal').exists?
	@browser.link(:text => 'MyMLBC Portal').click
	30.times { break if (begin @browser.text.include? "My News Feed" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }	
end

@browser.goto @browser.link(:text => /Edit Profile/i).attribute_value("href")

30.times { break if (begin @browser.button(:text => /Edit Profile/i).exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
#puts "incoming onclick"
#puts @browser.button(:value => /Edit Profile/i).attribute_value("onclick")
@browser.execute_script @browser.button(:value => /Edit Profile/i).attribute_value("onclick")

30.times { break if (begin @browser.text_field(:id => "business_name").exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

@browser.select_list(:id => 'category_id').option(:text => /#{data['category'].strip}/i).click

@browser.text_field(:id => 'business_name').set data['business']
@browser.text_field(:id => 'business_street1').set data['address']
@browser.text_field(:id => 'business_street2').set data['address2']
@browser.text_field(:id => 'business_zip').set data['zip']
@browser.text_field(:id => 'business_city').set data['city']
@browser.select_list(:id => 'business_state').select data['state']

@browser.text_field(:id => 'business_phone').set data['phone']
@browser.text_field(:id => 'business_phone2').set data['altphone']
@browser.text_field(:id => 'business_fax').set data['fax']
@browser.text_field(:id => 'business_url').set data['website']
@browser.text_field(:id => 'business_hours').set data['hours']
@browser.text_field(:id => 'contact_name').set data['firstlast']
@browser.text_field(:id => 'business_name').set data['business']

if not self.logo.nil?
	puts "INCOMING LOGO #{self.logo}"
	@browser.file_field(:id => 'profile_lg').set self.logo
end

@browser.button(:id => 'mySubmit').click

30.times { break if (begin @browser.text.include? "My Profile" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

true

