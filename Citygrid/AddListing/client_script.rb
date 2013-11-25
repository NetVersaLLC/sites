@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

@browser.goto "https://signup.citygrid.com/self_enroll/add_location"

@browser.text_field( :id => /first_name/).set data['fname']
@browser.text_field( :id => /last_name/).set data['lname']
@browser.text_field( :id => /listing_email/).set data['email']
@browser.text_field( :id => /contact_phone/).set data['mobile']
@browser.text_field( :id => /listing_name/).set data['business']
@browser.text_field( :id => /listing_address_1/).set data['address']
@browser.text_field( :id => /listing_city/).set data['city']
@browser.select_list( :id => /listing_state/).set data['state']
@browser.text_field( :id => /listing_zip/).set data['zip']
@browser.text_field( :id => /listing_phone/).set data['phone']
@browser.text_field( :id => /listing_website/).set data['website']

