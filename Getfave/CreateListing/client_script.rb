#Search Business
url = 'https://www.getfave.com/login'
@browser.goto url

sign_in data

sleep 10

change_location data

sleep 10

queryurl = "https://www.getfave.com/search?utf8=%E2%9C%93&q=#{data['bus_name_fixed']}"
@browser.goto queryurl

Watir::Wait.until { @browser.div(:id => 'results').exists? }

if @browser.text.include? "We couldn't find any matches."
  #Add business
  @browser.link(:href => 'https://www.getfave.com/businesses/new').click
  fill_business data

  true
elsif @browser.div(:id => 'business-results').span(:text => "#{data['business']}").exist?
  puts "Business is already listed."
  true
end
