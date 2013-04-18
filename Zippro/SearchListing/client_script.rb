require 'nokogiri'
url = "http://#{data['zip']}.zip.pro/#{data['businessfixed']}"
puts(url)
page = Nokogiri::HTML(RestClient.get(url)) 
if not page.css("div.organicListing").length == 0
  link = page.css("a.result-title")
  link = link[0]["href"]
  subpage = Nokogiri::HTML(RestClient.get(link)) 
  claimLink = subpage.css("a#a_prof_claim")
  if claimLink.length == 0
    businessFound = [:listed, :claimed]
  else
    businessFound = [:listed, :unclaimed]
  end 
else
  businessFound = [:unlisted]
end


[true, businessFound]