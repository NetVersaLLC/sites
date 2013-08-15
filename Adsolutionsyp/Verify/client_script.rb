sign_in(data)

begin
	@browser.link(:text => "Verify").when_present.click
rescue
	throw("No option to verify. Listing has already been verified.")
end

begin
	sleep 3
	Watir::Wait.until { @browser.link(:id => 'verifyStartPhoneLink').exists? }
	@browser.link(:id => 'verifyStartPhoneLink').click

	thecode = @browser.div(:xpath => '//*[@id="calingDiv"]/div').text
	if PhoneVerify.send_code("adsolutionsyp", thecode)
		30.times{break if not @browser.div(:xpath => '//*[@id="calingDiv"]/div').exists?; sleep 5}
		true
	else
		throw("Phone verify failed")
	end

rescue Exception => e
	puts(e.inspect) #declineButton
	if @browser.button(:class => 'declineButton').exists?
		@browser.button(:class => 'declineButton').click
		retry
	end
end



