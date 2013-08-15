 # Main Script start from here
# Launch url
url = 'http://my.citysquares.com/search'
@browser.goto url
30.times{ break if @browser.status == "Done"; sleep 1}
@browser.text_field(:name => 'b_standardname').set data['business'] 
@browser.text_field(:name => 'b_zip').set data['zip'] 
@browser.button(:value => 'Find My Business').click
30.times{ break if @browser.status == "Done"; sleep 1}
if matching_result data
  puts "Claiming existing business listing"
  claim_business data
else 
  puts "Business is not listed!"
end
true