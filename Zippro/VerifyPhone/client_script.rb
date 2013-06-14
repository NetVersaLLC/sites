sign_in(data)

sleep(3)

@browser.goto("http://myaccount.zip.pro/profile-manager.php")
phoneverified = false
retries = 5
begin
	@browser.link(:text => /PIN/).click

	sleep(3)
	@browser.radio(:id => 'now').when_present.click
	@browser.button(:id => 'ipinGenSubmit').click

	code = PhoneVerify.ask_for_code
	@browser.text_field(:name => 'ipin_text').set code
	@browser.button(:id => 'btnPinVerify').click

	sleep 5
	if @browser.text.include? "PIN entered is incorrect."
		raise "PIN was incorrect."
	else
		phoneverified = true
	end

rescue RuntimeError
	puts(e.inspect)
	if retries > 0
		retries -= 1
		retry
	else
		throw "The PIN was not entered correctly after 5 tries."
	end
rescue Exception => e
	puts(e.inspect)
end

if phoneverified
	self.start("Zippro/FinishListing")
end

true
