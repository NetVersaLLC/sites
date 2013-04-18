url = "http://www.shopcity.com/map/mapnav_locations.cfm?region=1001&state="+data['state_short']

cities = Nokogiri::HTML(RestClient.get(url))  
citylink = cities.css("a.navlinks").select{|a|a.text =~ /#{data['citystatelong']}/}
citylink = citylink[0]['href']
searchLink = citylink + "/search/inner_results.cfm?where=#{data['citystate']}&action=search&type=businesses&q=#{data['businessfixed']}&categories_search=1&business_posts_search=1&business_search=1&marketplace_search=1%20HTTP/1.1"
page = Nokogiri::HTML(RestClient.get(searchLink))

thelist = page.css("div.business_title_area a")

businessFound = [:unlisted]
thelist.each do |item|
next if item.text =~ /report mistake/
  next if not item.text =~ /#{data['business']}/i  
  thelink = item['href']
  subpage = Nokogiri::HTML(RestClient.get(thelink)) 
    
  if subpage.xpath('//*[@id="toppod"]/tbody/tr[2]/td[2]/div/div[1]/div/a/b').length == 0
    
    businessFound = [:listed, :claimed]
    break
  else
    businessFound = [:listed, :unclaimed]
    break
  end

end

[true, businessFound]