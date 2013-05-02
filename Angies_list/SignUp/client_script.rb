@browser.goto( 'https://business.angieslist.com/Registration/Registration.aspx' )

@browser.execute_script("javascript:__doPostBack('ctl00$ContentPlaceHolderMainContent$SimpleRegistrationWizard$SelectCompanyControl$AddCompanyButton','')")

sleep 2
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyName/).when_present.set data['company_name']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyAddress/).set data['address']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyCity/).set data['city']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyState/).set data['state']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyPostalCode/).set data['zip']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyPhone/).set data['phone']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyEmail/).set data['email']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyContactFirstName/).set data['first_name']
@browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyContactLastName/).set data['last_name']




@browser.checkbox(:id => 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_ProviderTypeCheckboxList_0').click
@browser.checkbox(:id => 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_ProviderTypeCheckboxList_1').click
@browser.checkbox(:id => 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_ProviderTypeCheckboxList_2').click
sleep(3)
@browser.select_list(:id,/AddCompanyControl_CategorySelections_leftlstbox/).when_present.select data['category']
@browser.button(:value,'>').click
sleep(3)
@browser.div(:class,'lightboxcontentbackground paddedmargin10').image(:alt,'Continue').click

 
@validation_error = @browser.div(:id,/ValidationSummary/)
if @validation_error.exist?
	throw("Please correct these value:#{@validation_error.text}")
end
@browser.text_field(:id,/SPAFirstName/).set data[ 'first_name' ]
@browser.text_field(:id,/SPALastName/).set data[ 'last_name' ]
@browser.text_field(:id,/SPAEmail/).set data[ 'email' ]
@browser.checkbox(:id,/AgreementCheckbox/).focus

@browser.execute_script( "$('input[id=ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_SetupAccountAccessControl_AgreementCheckbox]').attr('checked', true);" )

retries = 1
begin
	@browser.text_field(:id,/SPAPassword/).set data[ 'password' ]
	@browser.text_field(:id,/SPAPasswordConfirm/).set data[ 'password' ]
	@browser.image(:alt,'Submit').click 

	sleep 2
	Watir::Wait.until(15) { @browser.text.include? 'Thank you for registering!' }

rescue Watir::Wait::TimeoutError
	if retries > 0
		@browser.div(:id => /AccountValidationSummary/i).ul.lis.each do |validerror|
			puts(validerror.text)
			if validerror.text =~ /Password must be 6-15 characters long with letters or digits/
				puts("AngiesList did not like the password given. Trying another one.")
				data['password'] = data['password2']
				break
			end
		end	
		retries -= 1
		retry	
	else
		throw "Account creation failed."
	end
rescue Exception => e
	puts(e.inspect)
end


	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'AngiesList'
	if @chained
		self.start("Angies_list/UpdateListing")
	end
	true

