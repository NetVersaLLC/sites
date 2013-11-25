@browser = Watir::Browser.new
at_exit {
	unless @browser.nil?
		@browser.close 
	end
}

@browser.goto 'http://www.bigwigbiz.com/createaccount.php?err=1&id=0'

@browser.text_field(:name => 'email_id').set data['email']
@browser.text_field(:name => 'login_id').set data['username']
@browsertext_field(:name => 'password').set data['password']
@browser.text_field(:name => 'cpd').set data['password']
@browser.text_field(:name => 'fname').set data['contact_first_name']
@browser.text_field(:name => 'lname').set data['contact_last_name']
@browser.text_field(:name => 'ph_no').set data['local_phone']
@browser.text_field(:name => 'company_name').set data['business_name']
@browser.textarea(:name => 'company_description').set data['business_description']
@browsertext_field(:name => 'state').set data['state']
@browsertext_field(:name => 'city').set data['city']
@browser.text_field(:name => 'zip').set data['zip']
@browser.select_list(:name => 'country').select 'United States'
@browser.textarea(:name => 'company_address').set data['address']
@browser.button(:name => 'submit').click
@browser.select_list(:name => 'sub_cat_id').when_present.select data['category']
@browser.select_list(:name => 'country').select 'United States'
@browsertext_field(:name => 'state').set data['state']
@browsertext_field(:name => 'city').set data['city']
@browser.text_field(:name => 'zip').set data['zip']
@browser.text_field(:name => 'url').set data['website']
@browser.button(:name => 'submit').click

sleep 5

if @browser.text.include? "Approved"
	true
else
	raise "Payload did not make it to end result"
end