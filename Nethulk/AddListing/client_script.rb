@browser = Watir::Browser.new
at_exit{
	unless @browser.nil?
		@browser.close
	end
}

@browser.goto 'http://www.nethulk.com/business_sign_up.php'

@browser.text_field(:name => 'm_name_bus').set data['business_name']
@browser.text_field(:name => 'm_email_bus').set data['email']
@browser.text_field(:name => 'm_phone_bus').set data['local_phone']
@browser.text_field(:name => 'm_fax_bus').set data['fax_number']
@browser.text_field(:name => 'm_addr_bus').set data['address']
@browser.text_field(:name => 'm_city_bus').set data['city']
@browser.select_list(:name => 'm_state_bus').select data['state']
@browser.text_field(:name => 'm_zip_bus').set data['zip']
@browser.text_field(:name => 'm_url').set data['company_website']
@browser.text_field(:name => 'm_name').set data['contact_first_name']
@browser.text_field(:name => 'm_email').set data['email']
@browser.text_field(:name => 'm_phone').set data['mobile_phone']
@browser.text_field(:name => 'm_addr').set data['address']
@browser.text_field(:name => 'm_city').set data['city']
@browser.select_list(:name => 'm_state').select data['state']
@browser.text_field(:name => 'm_zip').set data['zip']
@browser.textarea(:name => 'm_desc').set data['business_description']
@browser.button(:id => 'submit').click

sleep 5

if @browser.text.include? "Business Update Successful"
	true
else
	raise "Payload did not submit correctly"
end