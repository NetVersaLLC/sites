# Search for the business
@browser.goto( "http://www.citygrid.com" )
@browser.text_field( :id => 'what' ).set data[ 'business_name' ]
@browser.text_field( :id => 'where' ).set data[ 'zip' ]
@browser.button( :id => 'find_btn' ).click


# Open the business page - search the link by text or a class
# Work around for case sensitive issue - https://github.com/watir/watir-webdriver/issues/72
business_text_link = @browser.link( :text => data[ 'business_name' ] )
business_class_link = @browser.link( :class => 'search_result_name' )

if business_text_link.exists?

  business_text_link.click

elsif business_class_link.exists?

  business_class_link.click

else

  puts "Business named " + data[ 'business_name' ] + " near " + data[ 'zip' ] + " is not found"
  # assert Browser.text "Sorry, we did not find any matches for abra near 65202 "
  Kernel::exit

end


# Claim the business
@browser.a( :text => 'Own This Business' ).click
@browser.text_field( :id => 'user_first_name' ).set data[ 'first_name' ]
@browser.text_field( :id => 'user_last_name' ).set data[ 'last_name' ]
@browser.text_field( :id => 'user_phone_area' ).set data[ 'phone_area' ]
@browser.text_field( :id => 'user_phone_prefix' ).set data[ 'phone_prefix' ]
@browser.text_field( :id => 'user_phone_suffix' ).set data[ 'phone_suffix' ]
@browser.text_field( :id => 'user_email' ).set data[ 'email' ]
@browser.text_field( :id => 'user_password' ).set data[ 'password' ]
@browser.text_field( :id => 'user_password_confirmation' ).set data[ 'password' ]
@browser.button( :id => 'create_account_button' ).click


# assert( @browser.text.include? "Verify" ) #and call_button
raise 'Not on verify page' unless @browser.text.include? 'Verify'

number = @browser.( :id, "call_button").value
number = number.slice! "Call me now at "
code = PhoneVerify.ask_for_code(number)
@browser.text_field( :id, "code_field").set code

@browser.checkbox( :id => 'check-agree' ).set
@browser.button( :id => 'check_button' ).click
