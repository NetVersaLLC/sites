sign_in(data)

@browser.link(:text => "Verify").when_present.click

@browser.link(:id => 'verifyStartPhoneLink').when_present.click

thecode = @browser.div(:xpath => '//*[@id="calingDiv"]/div').text
if PhoneVerify.enter_code(thecode)
	true
else
	throw("Phoen verify failed")
end


