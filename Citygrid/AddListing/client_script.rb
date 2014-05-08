@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

@browser.goto "https://signup.citygrid.com/self_enroll/add_location"

# @browser.text_field( :id => /first_name/).set data['fname']
# @browser.text_field( :id => /last_name/).set data['lname']
# @browser.text_field( :id => /listing_email/).set data['email']
# @browser.text_field( :id => /contact_phone/).set data['mobile']
# @browser.text_field( :id => /listing_name/).set data['business']
# @browser.text_field( :id => /listing_address_1/).set data['address']
# @browser.text_field( :id => /listing_city/).set data['city']
# @browser.select_list( :id => /listing_state/).set data['state']
# @browser.text_field( :id => /listing_zip/).set data['zip']
# @browser.text_field( :id => /listing_phone/).set data['phone']
# @browser.text_field( :id => /listing_website/).set data['website']
@browser.text_field( :id => /create_new_listing_first_name/).set data['first_name']
@browser.text_field( :id => /create_new_listing_last_name/).set data['last_name']
@browser.text_field( :id => /create_new_listing_email/).set data['email']
@browser.text_field( :id => /create_new_listing_contact_phone/).set data['mobile-phone']
@browser.text_field( :id => /create_new_listing_name/).set data['business_name']
@browser.text_field( :id => /create_new_listing_address_1/).set data['address']
@browser.text_field( :id => /create_new_listing_city/).set data['city']
@browser.select_list(:id => 'create_new_listing_state').select 'IN'
@browser.text_field( :id => /create_new_listing_zip/).set data['zip']
@browser.text_field( :id => /create_new_listing_phone/).set data['phone']

@browser.link(:xpath,'/html/body/div[4]/div[2]/form/div[6]/div[2]/div[2]/div/div/div/div/a').click
@browser.text_field(:xpath, '/html/body/div[11]/div/input').set data['category']

sleep 5
@browser.element(:css => '.select2-highlighted').click

@browser.text_field( :id => /create_new_listing_website_url/).set data['website']
sleep(25)
@browser.button(:id=>'create-listing').click 
sleep 15
if @browser.div(:class=>'empty-profile').exists?
	 true
else
	 false
end	
