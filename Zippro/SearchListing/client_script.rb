require 'nokogiri'
url = "http://#{data['zip']}.zip.pro/#{data['businessfixed']}"
puts(url)
page = Nokogiri::HTML(RestClient.get(url)) 
if not page.css("div.organicListing").size == 0
  link = page.css("a.result-title")
  link2 = link[0]["href"]
  subpage = Nokogiri::HTML(RestClient.get(link2)) 
  claimLink = subpage.css("a#a_prof_claim")
  if claimLink.size == 0
    puts("Claimed")
    businessFound = [:listed, :claimed]
  else
    puts("Unclaimed")
    businessFound = [:listed, :unclaimed]
  end 
else
  puts("Unlisted")
  businessFound = [:unlisted]
end


[true, businessFound]