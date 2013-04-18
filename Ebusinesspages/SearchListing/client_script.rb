url = "http://ebusinesspages.com/search.aspx?co=#{data['businessfixed']}&loc=#{data['city']}%2C+#{data['state_short']}"
page = Nokogiri::HTML(RestClient.get(url))  

thelist = page.css("div.SI a")

businessFound = [:unlisted]
thelist.each do |item|
  next if not item.text =~ /#{data['business']}/i  
  puts(item.text)
  thelink = "http://ebusinesspages.com/"+item['href']
  puts(thelink)
  subpage = Nokogiri::HTML(RestClient.get(thelink))  
  if subpage.css("a#bVerifyButton").length == 0
    businessFound = [:listed, :claimed]
    break
  else
    businessFound = [:listed, :unclaimed]
    break
  end
end
[true, businessFound]