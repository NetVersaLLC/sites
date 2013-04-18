# Launch url
url = 'http://www.opentable.com/'
@browser.goto(url)
@browser.link(:text => 'manage reservations with OpenTable.').click
@browser.link(:text => 'Join Us').click
@browser.text_field(:name => 'first_nameEng').set data[ 'first_name' ] 
@browser.text_field(:name => 'last_nameEng').set data[ 'last_name' ] 
@browser.text_field(:name => 'email').set data[ 'email' ] 
@browser.text_field(:name => 'company').set data[ 'business' ] 
@browser.text_field(:name => 'phone').set data[ 'phone' ] 
@browser.text_field(:name => 'city').set data[ 'city' ] 
@browser.select_list(:name => 'state').select data[ 'state' ] 
@browser.select_list(:name => 'countryDropDown').select data[ 'country' ] 
@browser.button(:name,'btnSubmit').click
#Error message
validation_error = @browser.div(:id,'ValidationSummary1').text

#Check for registration status
final_message = @browser.div(:class,'completed')
success_message = "Thank you. We'll be in touch shortly"


if final_message.exist? && final_message.text.include?(success_message)
  puts "Registration Successful"
  true
else
  throw("Registration Unsuccessful:#{validation_error}")
  false
end



