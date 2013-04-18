url = "http://www.ibegin.com/search/phone/?phone=#{data['phone']}"
puts(url)
page = Nokogiri::HTML(RestClient.get(url)) 
if not page.css("div.business").length == 0
  link = page.css("div.business a")
  link = "http://www.ibegin.com" + link[0]["href"]
  subpage = Nokogiri::HTML(RestClient.get(link)) 
  claimLink = subpage.css("li#axNavClaimit a")
  if claimLink.length == 0
    businessFound = [:listed, :claimed]
  else
    businessFound = [:listed, :unclaimed]
  end 
else
  businessFound = [:unlisted]
end
[true, businessFound]