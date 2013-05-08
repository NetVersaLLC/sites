# Search for the business
def claim_business(data)
  # Claim the business
  @browser.link(:text => data[ 'business_name' ]).click
  @browser.a( :text => 'Own This Business' ).click
  @browser.text_field( :id => 'user_first_name' ).set data[ 'first_name' ]
  @browser.text_field( :id => 'user_last_name' ).set data[ 'last_name' ]
  @browser.text_field( :id => 'user_phone' ).set data[ 'phone']
  @browser.text_field( :id => 'user_email' ).set data[ 'email' ]
  @browser.button( :id => 'create_account_button' ).click
  @browser.wait()
  @browser.text_field( :id => 'user_password' ).when_present.set data[ 'password' ]
  @browser.button( :id => 'create_account_button' ).click
  @browser.wait()
  @browser.text.include? 'Verify'
  number = @browser.button( :id, "call_button").when_present.value
  phone_number = number.slice! "Call me now at "
  puts "Calling the phone number #{number}"
#  @browser.button( :id, "call_button").when_present.click
  code = PhoneVerify.ask_for_code
  @browser.text_field( :id, "code_field").set code
  @browser.checkbox( :id => 'check-agree' ).set
  @browser.button( :id => 'check_button' ).click
end

def search_business(data)
  @found_business = false
  @browser.text_field( :id => 'what' ).set data[ 'business_name' ]
  @browser.text_field( :id => 'where' ).set data[ 'zip' ]
  @browser.button( :id => 'find_btn' ).click

  # Open the business page - search the link by text or a class
  # Work around for case sensitive issue - https://github.com/watir/watir-webdriver/issues/72
  business_text_link = @browser.link( :text => data[ 'business_name' ] )
  if business_text_link.exists?
     @found_business = true
  else
    puts "Business named " + data[ 'business_name' ] + " near " + data[ 'zip' ] + " is not found"
  end
  return @found_business
end

#main steps
@browser.goto( "http://www.citygrid.com" )

if search_business(data)
  puts "Claiming the business"
  claim_business(data) 
else
  puts "Business is not listed"  
  true
end
