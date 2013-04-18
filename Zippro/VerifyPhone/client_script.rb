sign_in(data)

sleep(3)

@browser.goto("http://myaccount.zip.pro/profile-manager.php")

@browser.link(:text => /PIN/).click

sleep(3)
@browser.radio(:id => 'now').when_present.click
@browser.button(:id => 'ipinGenSubmit').click

code = PhoneVerify.ask_for_code
@browser.text_field(:name => 'ipin_text').set code
@browser.button(:id => 'btnPinVerify').click

sleep(5)
if not @browser.text.include? "PIN entered is incorrect."

true

end

