sign_in_business(data)

sleep 2
@browser.link(:text => /Enter PIN/i).when_present.click

sleep 2
code = PhoneVerify.retrieve_code("Bing")
@browser.text_field(:id => 'Pin').when_present.set code

sleep 2
@browser.execute_script("ValidateAndPerformAjaxCall('SubmitVerificationPIN', '#enterPinForm')")

sleep 10
true