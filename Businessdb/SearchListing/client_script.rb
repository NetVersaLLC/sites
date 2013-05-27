#Main steps
url = 'http://www.businessdb.com/'
@browser.goto(url)

# Search busienss
businessFound = []

if search_business(data)
  puts "Business Already Exist"
  businessFound = [:listed,:unclaimed]
else
  businessFound = [:unlisted]
end

[true, businessFound]
