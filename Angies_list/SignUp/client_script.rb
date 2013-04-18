def service_group(group)
	group = 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_ProviderTypeCheckboxList_0' if group == ''
	if group == 'Consumer Services'
		group = 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_ProviderTypeCheckboxList_0'
	elsif group == 'Classic Car Services'
		group = 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_ProviderTypeCheckboxList_1'
	elsif group == 'Health Related Services'
		group = 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_ProviderTypeCheckboxList_2'
	end
	return group
end

# Claim Business
def claim_business(data)
	@browser.text_field(:id,/SPAFirstName/).set data[ 'first_name' ]
	@browser.text_field(:id,/SPALastName/).set data[ 'last_name' ]
	@browser.text_field(:id,/SPAEmail/).set data[ 'email' ]
	@browser.text_field(:id,/SPAPassword/).set data[ 'password' ]
	@browser.text_field(:id,/SPAPasswordConfirm/).set data[ 'password' ]
#	@browser.(:id,/ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_SetupAccountAccessControl_AgreementCheckbox/).set
#	@browser.span( :class, 'checkbox').click
	@browser.execute_script( "$('input[id=ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_SetupAccountAccessControl_AgreementCheckbox]').attr('checked', true);" )
	sleep(3)
	@browser.image(:alt,'Submit').click
	
	#Validation error
	@validation_error = @browser.div(:id,/ValidationSummary/)
	if @validation_error.exist?
		throw("Please correct these value:#{@validation_error.text}")
	elsif @browser.html.include?('Thank you for registering!')
		puts "Business listing claim successful"   
    
		true
	end
end	

#Search for specific business from matching results
def search_business(data)
	@browser.wait_until {@browser.div(:class , 'RegistrationLightbox').exist? }
	result_count = @browser.table(:class, 'wide100percent').rows.length

        #Search for matching result
	for n in 1...result_count
		result = @browser.table(:class, 'wide100percent')[n].text
		if result.include?(data[ 'company_name' ])
			@browser.table(:class, 'wide100percent')[n].image(:alt,'Select').click
			$matching_result = true
			break
		end
	end
	return $matching_result
end

# Main Script start from here
# Launch url
#@url = 'https://business.angieslist.com/'
#  @browser.goto(@url)
  
  #sign out
 # @sign_out = @browser.link(:text, 'Sign Out')
  #@sign_out.click if @sign_out.exist?
  
  #Fill form on Step -I
  @browser.goto( 'https://business.angieslist.com/Registration/Registration.aspx' )
  @browser.text_field(:id => /CompanyName/).set data[ 'company_name' ]
  @browser.text_field(:id => /CompanyZip/).set data[ 'zip' ]
  @browser.image(:alt,'Search').click
  sleep(5)
  
  #Check if business already listed
  @error_msg = @browser.span(:class,'errortext')
  @no_match_text = 'No companies were found. Try entering partial information in the search fields.'
  
  if not @browser.span( :text => /#{data['company_name']}/i).exists?
	  @browser.image(:alt,'Add Company').click
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyName/).when_present.set data['company_name']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyAddress/).set data['address']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyCity/).set data['city']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyState/).set data['state']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyPostalCode/).set data['zip']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyPhone/).set data['phone']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyEmail/).set data['email']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyContactFirstName/).set data['first_name']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').text_field(:id,/CompanyContactLastName/).set data['last_name']
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').checkbox(:id,service_group("#{data['service_group']}")).set
	  sleep(3)
	  @browser.select_list(:id,/AddCompanyControl_CategorySelections_leftlstbox/).when_present.select data['category']
	  @browser.button(:value,'>').click
	  sleep(3)
	  @browser.div(:class,'lightboxcontentbackground paddedmargin10').image(:alt,'Continue').click
	   
	   #check for validation error
	  @validation_error = @browser.div(:id,/ValidationSummary/)
	  if @validation_error.exist?
		  throw("Please correct these value:#{@validation_error.text}")
	  end
	  @browser.text_field(:id,/SPAFirstName/).set data[ 'first_name' ]
	  @browser.text_field(:id,/SPALastName/).set data[ 'last_name' ]
	  @browser.text_field(:id,/SPAEmail/).set data[ 'email' ]
	  @browser.text_field(:id,/SPAPassword/).set data[ 'password' ]
	  @browser.text_field(:id,/SPAPasswordConfirm/).set data[ 'password' ]
	  @browser.checkbox(:id,/AgreementCheckbox/).focus

	  @browser.execute_script( "$('input[id=ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_SetupAccountAccessControl_AgreementCheckbox]').attr('checked', true);" )
#	  @browser.checkbox(:id,/AgreementCheckbox/).click
	  @browser.image(:alt,'Submit').click 
	  
	  #check for validation error
	  if @validation_error.exist?
		  throw("Please correct these value:#{@validation_error.text}")
	  elsif @browser.html.include?('Thank you for registering!')
		  puts "Initial registration is successful"
	  end
	  
		@browser.button(:src,/close_btn/).click
		RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'AngiesList'
    
  if @chained
		self.start("Angies_list/UpdateListing")
	end
    
		true
	  
  elsif  search_business(data)
	  puts "Business already Listed"
	  claim_business(data)
	  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'AngiesList'
    if @chained
      self.start("Angies_list/UpdateListing")
    end
    true
  end
   

