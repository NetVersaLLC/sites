businessFound = {}
businessFound['status'] = :unlisted

if data['phone'] =~ /\(?(\d\d\d)\)?[-.]?\s*(\d\d\d)[-.]?\s*(\d\d\d\d)/
url = "http://ebusinesspages.com/(#{$1})#{$2}-#{$3}.tel"
page = Nokogiri::HTML(RestClient.get(url))
thelist = page.css("div.listCompany a")
thelist.each do |item|
  next if not item.text =~ /#{data['business']}/i  
  thelink = "http://ebusinesspages.com/"+item['href']
  subpage = Nokogiri::HTML(RestClient.get(thelink))  
  
  businessFound['listed_address'] = subpage.css("span[@itemprop='street-address']").text + ", " + subpage.css("span[@itemprop='locality']").text + ", " + subpage.css("span[@itemprop='region']").text + ", " + subpage.css("span[@itemprop='postalCode']").text 
  businessFound['listed_phone'] = data['phone']
  businessFound['listed_url'] = thelink
  businessFound['listed_name'] = subpage.css("span[@itemprop='name']").text

  businessFound['status'] = :claimed
  break
  
end
end
[true, businessFound]
