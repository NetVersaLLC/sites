 # Main Script start from here
# Launch url
url = 'http://my.citysquares.com/search'
@browser.goto url

@browser.text_field(:name => 'b_standardname').set data['business'] 
@browser.text_field(:name => 'b_zip').set data['zip'] 
@browser.button(:value => 'Find My Business').click
sleep 3
if matching_result data
  puts "Claiming existing business listing"
  claim_business data
else 
  throw "Business is not listed!"
end