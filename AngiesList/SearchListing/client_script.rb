def search_business(data)
	Watir::Wait.until {@browser.div(:class , 'RegistrationLightbox').exist? }
	result_count = @browser.table(:class, 'wide100percent').rows.length

	for n in 1...result_count
		result = @browser.table(:class, 'wide100percent')[n].text
		if result.include?(data[ 'business' ])
			@browser.table(:class, 'wide100percent')[n].image(:alt,'Select').click
			$matching_result = true
			break
		end
	end
	return $matching_result
end

 @browser.goto( 'https://business.angieslist.com/Registration/Registration.aspx' )
  @browser.text_field(:id => /CompanyName/).set data[ 'business' ]
  @browser.text_field(:id => /CompanyZip/).set data[ 'zip' ]
  @browser.image(:alt,'Search').click  
@browser.screenshot.save 'screenshot1.png'
sleep(2)
  Watir::Wait.until { @browser.div(:id => 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_SelectCompanyControl_SelectACompanyContainer') }
  @error_msg = @browser.span(:class,'errortext')    

if search_business(data)
    businessFound = [:listed,:unclaimed]
else
businessFound = [:unlisted]
end

[true, businessFound]
