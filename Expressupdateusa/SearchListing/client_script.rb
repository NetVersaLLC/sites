url = "http://listings.expressupdateusa.com/Search/Results?CompanyNameFilter=&State=&PhoneNumberFilter="+data['phone'].gsub("-","")
page = Nokogiri::HTML(RestClient.get(url))  

if page.css("div#EditListing").length == 0
  businessFound = [:unlisted]
else
  businessFound = [:listed, :unclaimed]
end

[true, businessFound]