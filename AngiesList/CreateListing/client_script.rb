	  # Update Profile
    
    @browser.goto('https://business.angieslist.com/')
    @browser.text_field( :id => 'ctl00_SignIn_UserName').set data['email']
    @browser.text_field( :id => 'ctl00_SignIn_Password').set data['password']
    @browser.button( :id => 'ctl00_SignIn_GoButton').click
    
	  #@browser.image(:alt,'Access your profile').click
	    #if @browser.div(:class,'Profile-Edit-Alert').exist?
	    if @browser.text.include? "Introducing the new Online Sales Dashboard!"
	    	@browser.link(:text, "Don't show me this message again").click
	    end

	    begin
	    @browser.goto("https://business.angieslist.com/MyAccount/CompanyInformation/Default.aspx")
	    Watir::Wait.until { @browser.text.include? "Company Profile" }
	    @browser.link(:id, /EditServiceAreaDescriptionButton/).click
	    loading_wait() #Detects if page is loading
	    @browser.textarea(:id, /ServiceAreaDescriptionTextBox/).set data['description']
	    @browser.button(:id, 'ctl00_ContentPlaceHolderMainContent_ProfileControl_ServiceAreaControl_ServiceAreaEditControl_ServiceAreaDescriptionSaveButton').click
	    loading_wait()
	    @browser.link(:id, /EditBusinessButton/).click
	    loading_wait()
	    @browser.textarea(:id, /BusinessDescription/).set data['business_description']
	    @browser.textarea(:id, /ServicesOffered/).set data['service_offered']
	    @browser.textarea(:id,/ServicesNotOffered/).set data['service_not_offered']
	    @browser.button(:id, 'ctl00_ContentPlaceHolderMainContent_ProfileControl_CategoryControl_ServiceOfferedEditControl_BusinessEditControl_EditBusinessSaveButton').click
	    loading_wait()
	    @browser.link(:id, 'ctl00_ContentPlaceHolderMainContent_ProfileControl_PaymentDetailControl_EditPaymentOptionButton').click
	    loading_wait()
	    @browser.select_list(:id, /SeniorDiscount/).select "No"
	    loading_wait()
	    @browser.select_list(:id, /FreeEstimates/).select "Ask for Details"
	    loading_wait()
	    @browser.radio(:value => "#{data['check']}", :id => /ctl01_PaymentTypeRadioButton/).when_present.set
		@browser.radio(:value => "#{data['visa']}", :id => /ctl02_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['mastercard']}", :id => /ctl03_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['american_express']}", :id => /ctl04_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['discover']}", :id => /ctl05_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['paypal']}", :id => /ctl06_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['financing_available']}", :id => /ctl07_PaymentTypeRadioButton/).set
		@browser.button(:id, 'ctl00_ContentPlaceHolderMainContent_ProfileControl_PaymentDetailControl_PaymentDetailEditControl_SaveButton').click
		loading_wait()
		@browser.link(:id, /EditBusinessDetailButton/).click
		loading_wait()
		@browser.text_field(:id, /BusinessDateTextBox/).set data['year_established']
		@browser.select_list(:id, /WarrantiesDropDownList/).select "ASK FOR DETAILS"
		@browser.select_list(:id, /ctl00_SetOpenDropDownList/).when_present.select clean_time( data['weekdays_opening_hours'] )
		loading_wait()
		@browser.select_list(:id, /ctl00_SetCloseDropDownList/).when_present.select clean_time( data['weekdays_closing_hours'] )
		loading_wait()
		@browser.select_list(:id, /ctl01_SetOpenDropDownList/).when_present.select clean_time( data['weekend_opening_hours'] )
		loading_wait()
		@browser.select_list(:id, /ctl01_SetCloseDropDownList/).when_present.select clean_time( data['weekend_closing_hours'] )
		loading_wait()
		@browser.button(:id, /BusinessDetailSaveButton/).click
		loading_wait()
		@browser.link(:id, /AddLicenseDetailButton/).click
		loading_wait()
		@browser.select_list(:id, /LicenseSignature/).when_present.select data['license_signature'] 
		loading_wait()
		@browser.button(:id, 'ctl00_ContentPlaceHolderMainContent_ProfileControl_LicenseDetailControl_LicenseDetailEditSection_SaveButton').click
		loading_wait()
		rescue
			if retries == 0
				puts("Failed after five retries.")
			end
			puts("Something went wrong! Retrying. #{retries} attempts remaining.")
			retry
			retries -= 1
		end
		if @browser.text.include? "Profile 100% Complete" then 
			puts("Profile successfully created")
			true
		else
			throw("Profile didn't create successfully")
		end
		#if @browser.wait_until {@thankyou_block.exists?}
		#	puts "Profile updated Successfully with message:#{@thankyou_block.text}"
      	#	true
=begin
		@browser.button(:alt,'Continue').when_present.click
		@browser.text_field(:id,/ServiceAreaDescription/).set data[ 'description' ]
		@browser.button(:id,'ctl00_ContentPlaceHolderMainContent_CocoFunnelSection_CoCoFunnelWizard_ServiceAreaEditControl_ServiceAreaDescriptionSaveButton').when_present.click
    sleep(5)
		@browser.link(:text,'Set all').click
		sleep(2)
		@browser.button(:id,'ctl00_ContentPlaceHolderMainContent_CocoFunnelSection_CoCoFunnelWizard_RegionZoneEditControl_RegionSaveButton').when_present.click
		@browser.wait_until {@browser.select_list(:id, /AddCategory_CategoryToSelect/).exist? }
		sleep(2)
		@browser.button(:id,'ctl00_ContentPlaceHolderMainContent_CocoFunnelSection_CoCoFunnelWizard_ServiceOfferedEditControl_AddCategory_AddCategorySaveButton').when_present.click
		@browser.text_field(:id,/BusinessDescription/).when_present.set data[ 'business_description' ]
		@browser.text_field(:id,/ServicesOffered/).set data[ 'service_offered' ]
		@browser.text_field(:id,/ServicesNotOffered/).set data[ 'service_not_offered' ]
		@browser.button(:id,'ctl00_ContentPlaceHolderMainContent_CocoFunnelSection_CoCoFunnelWizard_ServiceOfferedEdit_BusinessService_EditBusinessSaveButton').when_present.click
		Watir::Wait.until { @browser.text.include? 'Payment Details' }
		@browser.radio(:value => "#{data['check']}", :id => /ctl01_PaymentTypeRadioButton/).when_present.set
		@browser.radio(:value => "#{data['visa']}", :id => /ctl02_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['mastercard']}", :id => /ctl03_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['american_express']}", :id => /ctl04_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['discover']}", :id => /ctl05_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['paypal']}", :id => /ctl06_PaymentTypeRadioButton/).set
		@browser.radio(:value => "#{data['financing_available']}", :id => /ctl07_PaymentTypeRadioButton/).set
		@browser.button(:id,'ctl00_ContentPlaceHolderMainContent_CocoFunnelSection_CoCoFunnelWizard_PaymentDetailEditControl_SaveButton').when_present.click
		Watir::Wait.until { @browser.text.include? 'Business Details' }
		sleep(3)
		@browser.select_list(:id, /ctl00_SetOpenDropDownList/).when_present.select clean_time( data['weekdays_opening_hours'] )
		sleep(3)
		@browser.select_list(:id, /ctl00_SetCloseDropDownList/).when_present.select clean_time( data['weekdays_closing_hours'] )
		sleep(3)
		@browser.select_list(:id, /ctl01_SetOpenDropDownList/).when_present.select clean_time( data['weekend_opening_hours'] )
		sleep(3)
		@browser.select_list(:id, /ctl01_SetCloseDropDownList/).when_present.select clean_time( data['weekend_closing_hours'] )
		@browser.button(:id,'ctl00_ContentPlaceHolderMainContent_CocoFunnelSection_CoCoFunnelWizard_BusinessDetailEditControl_BusinessDetailSaveButton').when_present.click
		sleep 2
		Watir::Wait.until { @browser.text.include? 'License Details' }
		sleep 2
		@browser.select_list(:id, /LicenseSignature/).when_present.select data['license_signature'] 
		sleep 2
		@browser.button(:title,'Save').when_present.click
		sleep 2
		Watir::Wait.until { @browser.text.include? 'Thank you! 100% complete profile helps members find and contact you.' }
		@thankyou_block = @browser.div(:id,/ThankYouKenticoBlock/)
=end