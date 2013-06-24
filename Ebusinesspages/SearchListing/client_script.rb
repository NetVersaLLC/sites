data['businessfixed'] = data['business'].gsub(" ", "%20")
data['cityfixed'] = data['city'].gsub(" ", "%20")

url = "http://ebusinesspages.com/search.aspx?co=#{data['businessfixed']}&loc=#{data['cityfixed']},%20+#{data['state']}"
puts url

page = Nokogiri::HTML(RestClient.get(url))

thelist = page.css("div.SI a")

businessFound['status'] = :unlisted
thelist.each do |item|
  next if not item.text =~ /#{data['business']}/i  
  puts(item.text)
  thelink = "http://ebusinesspages.com/"+item['href']
  puts(thelink)
  subpage = Nokogiri::HTML(RestClient.get(thelink))  
  if subpage.css("a#bVerifyButton").length == 0
    businessFound['status'] = :claimed
    break
  else
    businessFound['status'] = :listed
    break
  end
end
[true, businessFound]