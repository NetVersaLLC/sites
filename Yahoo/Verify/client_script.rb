def verify_be_email()

  puts 'Verify by email'

  # Send confirmation email
  @browser.radio( :id => 'opt-email' ).set data['email']
  @browser.button( :id => 'btn-email' ).click
  sleep 20 # for email to arrive

  # Open mail box
  @browser.goto( 'http://mail.yahoo.com/' )

  # .. a) go to inbox and click verification link
  @browser.a( :id => 'tabinbox' ).click
  Watir::Wait::until do @browser.div( :class => 'list-view' ).exists? end
  @browser.div( :text => 'Text - Yahoo! email verification code' ).click
  # parse 'Your verification code is Vsp35sde.'
  verification_code = 'Vsp35sde'
  # parse link 'Please login to http://beta.listings.local.yahoo.com/verify/...'
  
  # .. b) serch mail by subject 'email verification code'
  # text_field :id => yuhead-sform-searchfield, button :class => yucs-sprop-btn

  # Complete verification by code
  @browser.text_field( :id => 'txtCaptcha' ).set verification_code
  @browser.button( :id => 'btnverifychannel' ).click
end

def verify_phone(data)

  sign_in(data)
  sleep 2

  @browser.link(:text => "Verify").when_present.click
  sleep(2)
  @browser.radio(:id => 'opt-phone').when_present.click
  sleep(2)

  

retries = 3
begin
  @browser.button(:id => 'btn-phone').when_present.click
    sleep(3)
  code = PhoneVerify.ask_for_code 
  @browser.text_field(:id => 'txtCaptcha').set code

  @browser.button(:id => 'btnverifychannel').click
  sleep 5

  if @browser.text.include? "The verification code you submitted was incorrect. Please enter the new verification code."
    throw "Invalid code."
  end
rescue
  if retries > 0
    puts("Invalid code. Trying again in 3 seconds...")
    sleep 3
    retries -= 1
    retry
  else
    throw "Could not verify the account"
  end
end


  true

end

verify_phone(data)
sleep 10 #Just waiting for the code to verify. Hard to find an element to wait for. 
true
#main( data )
