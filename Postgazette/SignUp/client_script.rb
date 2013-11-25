@browser = Watir::Browser.new
at_exit {
	unless @browser.nil?
		@browser.close 
	end
}

@browser.goto 'https://post-gazette.partners.local.com/'

@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_first_name').set data['contact_first_name']
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_last_name').set data['contact_last_name']
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_title').set data['business_name']
data['local_phone'].split(//).each { |number|
	@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_phone').send_keys number
}
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_login_email').set data['email']
data['fax_number'].split(//).each { |number|
	@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_fax').send_keys number
}
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_url').set data['company_website']
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_city').set data['city']
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_street_name').set data['address']
@browser.select_list(:id => 'ctl00_ContentPlaceHolder1_state').select data['state']
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_postal_code').set data['zip']
@browser.button(:name => 'ctl00$ContentPlaceHolder1$ctl00').click # Click to next page
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_primary_cat').when_present.click
sleep 3
@browser.text_field(:xpath => '//*[@id="ctl00_ContentPlaceHolder1_Category1"]').set data['category']
sleep 2
@browser.send_keys :down
sleep 1
@browser.send_keys :enter
@browser.button(:id => 'ctl00_ContentPlaceHolder1_Button1').click
sleep 3
@browser.div(:class => 'uList point').click
sleep 1
@browser.textarea(:id => 'ctl00_ContentPlaceHolder1_Description').when_present.set data['business_description']
@browser.button(:id => 'ctl00_ContentPlaceHolder1_Button1').click
sleep 3
@browser.button(:id => 'ctl00_ContentPlaceHolder1_Button3').click # Click to next page
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_register_password').set data['password']
@browser.text_field(:id => 'ctl00_ContentPlaceHolder1_register_confirm_password').set data['password']
@browser.button(:id => 'ctl00_ContentPlaceHolder1_button_free').click # Confirm listing

Watir::Wait.until { @browser.text.include? "Thank You!" }

true