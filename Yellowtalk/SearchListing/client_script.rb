def search_for_business( business )
url = "http://yellowtalk.com/findbusinesses.php"

businessFound = {}
@browser.goto(url)
sleep 5
Watir::Wait.until{ @browser.text.include? "Search the Interntet's Talking Yellow Pages Directory" }
@browser.text_field(:name => "keyword" ).when_present.set business['category']
@browser.text_field(:name => "region" ).set business['city']
@browser.text_field(:name => "name" ).set business['name']
puts ("about to enter the listing")
@browser.button(:name => "Submit").click
puts ("Clicked")
Watir::Wait.until{ @browser.text.include? "matching " }
puts("It did reach here")

if @browser.link(:title => /#{business['business']}/i).exists?
      businessFound['status'] = :listed
      thelinky = @browser.link(:title => /#{business['business']}/i)      
      businessFound['listed_name'] = thelinky.attribute_value("href")
      businessFound['listed_address'] = @browser.p(:xpath => '//*[@id="0"]/tbody/tr/td[2]/p[1]').text + @browser.p(:xpath => '//*[@id="0"]/tbody/tr/td[2]/p[2]').text
else
      businessFound['status'] = :unlisted
end
return businessFound
end

businessFound = search_for_business(data)
[true, businessFound]
puts(businessFound)