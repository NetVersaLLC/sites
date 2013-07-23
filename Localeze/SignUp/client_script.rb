url = 'http://www.neustarlocaleze.biz/directory/sign-up.aspx?UserAction=ADD#get-business/standard'
@browser = Watir::Browser.new
#@browser.maximize()
#@browser.speed = :slow

@browser.goto(url)
#@browser.link(:href => /get-started/).click
#@browser.close
#@browser = Watir::Browser.attach(:url, url)
#@browser.maximize()

#Step 1
puts("Adding new listing")
begin
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_txtBusinessName').set data[ 'business' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_txtDepartment').set data[ 'department' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_txtListingAddress').set data[ 'address' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_txtListingCity').set data[ 'city' ] 
	@browser.select_list(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_ddlState').select data[ 'state' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_txtListingZip').set data[ 'zip' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_txtPhone').set data[ 'phone' ] 

	@browser.text_field(:name,/txtCategory/).click
	@browser.text_field(:name,'category').set data[ 'category' ]

	begin
	@browser.span(:text,/#{data[ 'category' ].upcase}/).when_present.click
	@browser.link(:id,'btn-category-pop').click
	rescue
		@browser.span(:class,"name").click
		@browser.link(:id,'btn-category-pop').click
	end
	@browser.button(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_nextButton').click
rescue
	if retries > 0 then
		puts("Something went wrong. Retrying.")
		retries -= 1
		retry
	end
end

# Check for error message if any
	@error_header = @browser.div(:id,'ctl00_ContentPlaceHolderMain_BusinessInformation_ValidationSummary1')
	if @error_header.exist? && @error_header.text.include?('Please correct the marked field')
		throw("Throwing Error:#{@error_header.text}")
	end

  #Step -2
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtFirstName').set data[ 'first_name' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtLastName').set data[ 'last_name' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtAddress').set data[ 'address' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtCity').set data[ 'city' ] 
	@browser.select_list(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_ddlStates').select data[ 'state' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtZipCode').set data[ 'zip' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtPhoneNumber').set data[ 'phone' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtEmail').set data[ 'email' ] 
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_txtEmailConfirm').set data[ 'email' ] 
	@browser.button(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_nextButton').click
# Verify step -2
	@error_header_contact = @browser.div(:id,'ctl00_ContentPlaceHolderMain_UserContactInfo_ValidationSummary')
	if @error_header_contact.exist? && @error_header_contact.text.include?('Please correct the marked field')
		throw("Throwing Error:#{@error_header_contact.text}")
	end
retries = 5
begin
@browser.button(:id,'ctl00_ContentPlaceHolderMain_PhoneVerification_btnCallMe').click
code = PhoneVerify.retrieve_code("Localeze")
@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_PhoneVerification_txtVerificationCode').set code
@browser.button(:id, 'ctl00_ContentPlaceHolderMain_PhoneVerification_btnverify').click
rescue
	if retries > 0
		if @browser.text.include? "Your security code could not be verified."
       		puts("Incorrect Verification Code.")
		PhoneVerify.wrong_code('Localeze')
       	end
       	puts("Phone Verify Failed, retrying in 3 seconds.")
       retries -= 1
       sleep 3
       retry
   else
       puts("Rescue failure.")
   end
end
sleep(4)

if not @browser.text_field(:id => 'ctl00_ContentPlaceHolderMain_UsernamePassword_txtUsername', :disabled => 'disabled').exists? then
	@browser.text_field(:id, 'ctl00_ContentPlaceHolderMain_UsernamePassword_txtUsername').set data['username']
end
@browser.text_field(:id, 'ctl00_ContentPlaceHolderMain_UsernamePassword_txtPassword').set data['password']
@browser.text_field(:id, 'ctl00_ContentPlaceHolderMain_UsernamePassword_txtPassword2').set data['password']

@browser.button(:name, 'ctl00$ContentPlaceHolderMain$UsernamePassword$btn_Next').click
sleep(4)

if @browser.text.include? "Success!"
	puts("Sign Up Successful")
	self.save_account("Localeze", {:email => data[ 'email' ], :password => data['password']})
else
	puts("SignUp did not save details")
end

if @chained == true
	self.start("Localeze/Verify")
end

true