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
  @browser.goto("http://smallbusiness.yahoo.com/dashboard/mybusinesses?brand=local")
  @browser.link(:text => "Verify").when_present.click
  sleep(2)
  @browser.radio(:id => 'opt-phone').when_present.click
  sleep(2)
  @browser.button(:id => 'btn-phone').when_present.click

  sleep(3)

  code = PhoneVerify.ask_for_code 
  @browser.text_field(:id => 'txtCaptcha').set code

  @browser.button(:id => 'btnverifychannel').click

  true

end

verify_phone(data)

#main( data )
