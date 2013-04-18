

begin
	@browser.button(:id,'ctl00_ContentPlaceHolderMain_PhoneVerification_btnCallMe').click
	@browser.text_field(:id,'ctl00_ContentPlaceHolderMain_PhoneVerification_txtVerificationCode').set data[ 'phone_verification' ]

rescue Exception => e
  puts("Exception Caught in Verify Phone")
  puts(e)
end
