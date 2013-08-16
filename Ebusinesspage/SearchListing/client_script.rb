#require 'rest-client'
#require 'nokogiri'

#data = {}
#data['business']  = "Lets Fly Cheaper"
#data['phone'] = "8002400461"

p1 = data['phone'][0,3]
p2 = data['phone'][3,3]
p3 = data['phone'][6,4]

url = "http://ebusinesspages.com/(#{p1})#{p2}-#{p3}.tel"


#url = "http://ebusinesspages.com/search.aspx?co=#{data['businessfixed']}&loc=#{data['cityfixed']},%20+#{data['state']}"
puts url

page = Nokogiri::HTML(RestClient.get(url))

thelist = page.css("div.listCompany a")
businessFound = {}
businessFound['status'] = :unlisted
thelist.each do |item|
  next if not item.text =~ /#{data['business']}/i  
  puts(item.text)
  thelink = "http://ebusinesspages.com/"+item['href']
  puts(thelink)
  subpage = Nokogiri::HTML(RestClient.get(thelink))  
  
  businessFound['listed_address'] = subpage.css("span[@itemprop='street-address']").text + ", " + subpage.css("span[@itemprop='locality']").text + ", " + subpage.css("span[@itemprop='region']").text + ", " + subpage.css("span[@itemprop='postalCode']").text 
  businessFound['listed_phone'] = data['phone']
  businessFound['listed_url'] = thelink
  businessFound['listed_name'] = subpage.css("span[@itemprop='name']").text

  businessFound['status'] = :claimed
  break
  
end
#puts businessFound
[true, businessFound]