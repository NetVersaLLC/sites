def signup (data)
	tries ||= 5
	@browser.goto "http://register.nsphere.net/Register.aspx"
	@browser.text_field(:id, "ctl00_contentMainLeft_txtCompanyName").set 		data['business_name']
	@browser.select_list(:id, "ctl00_contentMainLeft_txtCategoryBase").select 	data['category']
	@browser.text_field(:id, "ctl00_contentMainLeft_txtAddress1").set 			data['address']
	@browser.text_field(:id, "ctl00_contentMainLeft_txtCity").set 				data['city']
	@browser.select_list(:id, "ctl00_contentMainLeft_txtStateCode").select 		data['state']
	@browser.text_field(:id, "ctl00_contentMainLeft_txtZipCode").set 			data['zip']
	@browser.text_field(:id, "ctl00_contentMainLeft_txtFirstName").set 			data['contact_first_name']
	@browser.text_field(:id, "ctl00_contentMainLeft_txtLastName").set 			data['contact_last_name']
	@browser.text_field(:id, "ctl00_contentMainLeft_txtEmail").set 				data['email']
	@browser.text_field(:id, "ctl00_contentMainLeft_txtPhoneNumber").set 		data['phone']
	@browser.button(:value,"REGISTER").click
rescue => e
	if (tries -= 1) > 0
		puts "Nsphere/SignUp failed. Retrying #{tries} more times."
		puts "Details: #{e.message}"
		sleep 2
		retry
	else
		puts "Nsphere/SignUp failed. Out of retries. Quitting."
		raise e
	end
else
	puts "Nsphere/SignUp succeeded!"
	credentials = {
		:email => data['email'],
		:username => data['email'],
		:password => data['password']
	}
	self.save_account("Nsphere", credentials)
	true
end

@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

signup data