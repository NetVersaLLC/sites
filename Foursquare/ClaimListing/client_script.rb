


def claim_listing( data )

sleep 2
@browser.link( :text, 'Claim it now.').when_present.click

sleep 2
Watir::Wait.until { @browser.checkbox(:id => 'agree').exists? or @browser.text_field( :id, 'phoneField').exists?}
puts "1"
if @browser.checkbox( :id, 'agree' ).visible?
	@browser.checkbox( :id, 'agree' ).click
	puts "2"
	sleep 4
	@browser.span( :text, 'Get Started').click
	puts "3"
end
puts "4"
sleep(3)
@browser.text_field( :id, 'phoneField').when_present.set data[ 'phone' ]
puts "5"
sleep(3)
@browser.span( :text, 'Call Me Now').when_present.click
puts "6"
sleep 2
code = @browser.text_field(:id, 'phoneField').when_present.value
puts "7" + code
verified = PhoneVerify.send_code("foursquare", code)
puts "8"
until @browser.span( :text, 'Continue').visible?
	puts "9"
	sleep 3
	puts "waiting for verification to finish"
end
puts "10"
sleep 3

@browser.checkbox( :id, 'finalVerificationOption' ).when_present.click
puts "11"
sleep 2
@browser.link( :text, 'Mail me a verification code!').when_present.click
puts "12"

end


sign_in( data )

@browser.goto data['business_url']

claim_listing( data )

