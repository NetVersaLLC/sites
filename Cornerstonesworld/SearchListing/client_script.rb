url = "http://www.cornerstonesworld.com/en/directory/country/USA/keyword/#{data['businessfixed']}/zip/#{data['zip']}/new"
page = Nokogiri::HTML(RestClient.get(url))  
firstItem = page.css("span.titlesmalldblue")

if firstItem.length == 0
  businessFound = [:unlisted]
else
   if firstItem.text == data['business']
      businessFound = [:listed, :unclaimed]     
   else
      businessFound = [:unlisted]      
   end  
end

[true,businessFound]