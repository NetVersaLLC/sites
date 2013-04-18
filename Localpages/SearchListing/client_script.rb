url = "http://www.localpages.com/#{data['state_short']}/#{data['city']}/#{data['businessfixed']}"
page = Nokogiri::HTML(RestClient.get(url)) 
thelist = page.css("ul.results_list").css("li.results_listing")
if not thelist.length == 0
  link = thelist.css("a")
  link = link[0]["href"]
  subpage = Nokogiri::HTML(RestClient.get(link)) 
  claimLink = subpage.xpath("/html/body/div[2]/div/div[3]/div[1]/div[3]/div[2]/a")
  if claimLink.length == 0
    businessFound = [:listed, :claimed]
  else
    businessFound = [:listed, :unclaimed]
  end 
else
  businessFound = [:unlisted]
end
[true, businessFound]
