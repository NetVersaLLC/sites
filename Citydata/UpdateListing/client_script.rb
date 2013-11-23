@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end
@browser.goto "http://www.city-data.com/profiles/account"

@browser.text_field(:name => 'login').set data['email']
@browser.text_field(:name => 'pass').set data['pass']

@browser.button(:value => 'Login').click

sleep 4
30.times { break if (begin @browser.text.include? "Make sure your profile is as in-depth as possible and provides" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

@browser.button(:value => 'Edit profile').click
sleep 4

30.times{ break if @browser.status == "Done"; sleep 1}


@browser.text_field(:name => 'name').set data['business']
@browser.text_field(:name => 'addr1').set data['address1']
@browser.text_field(:name => 'addr2').set data['address2']
@browser.text_field(:name => 'city').set data['city']
@browser.select_list(:name => 'state').select data['state']
@browser.text_field(:name => 'zip').set data['zip']
@browser.text_field(:name => 'phone').set data['phone']
@browser.text_field(:name => 'fax').set data['fax']
@browser.text_field(:name => 'work_hours').set data['hours']
@browser.text_field(:name => 'year_established').set data['founded']
@browser.select_list(:name => 'cc_accept').select data['ccaccepted']
#@browser.select_list(:name => 'empl_num').select data['employees']
#cats
@browser.select_list(:name => 'cat').select data['category']

description = data['description']
if description.length < 349
	description = description + " " + description
end

@browser.textarea(:name => 'descr').set data['description']

@browser.button(:value => 'Save changes').click

sleep 4
30.times{ break if @browser.status == "Done"; sleep 1}

true