sign_in(data)

begin
	# Clicking is hit or miss. This workaround works.
	Watir::Wait.until { @browser.text.include? "Welcome to Your Online Account Services!" }
	verify = @browser.link(:text => "Verify").href
	@browser.goto(verify)
rescue
	throw("No option to verify. Listing has already been verified.")
end

begin
	sleep 3
	@browser.link(:id => 'verifyStartPhoneLink').when_present.click

	thecode = @browser.div(:xpath => '//*[@id="calingDiv"]/div').text
	if PhoneVerify.send_code("adsolutionsyp", thecode)
		30.times{break if not @browser.div(:xpath => '//*[@id="calingDiv"]/div').exists?; sleep 5}
		true
	else
		throw("Phone verify failed")
	end

rescue => e
	puts(e.inspect) #declineButton
	if @browser.button(:class => 'declineButton').exists?
		@browser.button(:class => 'declineButton').click
		retry
	end
end



