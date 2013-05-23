#Search for existing listing
if search_business(data)
  puts "Business Already Exist"
  true
end

#Main steps
url = 'http://www.businessdb.com/'
@browser.goto(url)
# Search busienss
search_business(data)
