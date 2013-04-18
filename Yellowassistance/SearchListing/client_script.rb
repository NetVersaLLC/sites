url = "http://www.yellowassistance.com/frmBusResults.aspx?nas=a&nam=#{data['businessfixed']}&cas=r&cat=#{data['businessfixed']}&mis=a&mil=&zis=a&zip=#{data['zip']}&cis=r&cit=#{data['city']}&sts=r&sta=KS&typ=bus&set=a&myl=&slat=&slon="
page = Nokogiri::HTML(RestClient.get(url))  
thelist = page.css("td.Verdana12 a")

businessFound = [:unlisted]
thelist.each do |item|
  next if not item.text =~ /#{data['business']}/i  
  thelink = "http://www.yellowassistance.com/"+item['href']
  subpage = Nokogiri::HTML(RestClient.get(thelink))  
  if subpage.css("a#lnkListing").length == 0
    businessFound = [:listed, :claimed]
    break
  else
    
    businessFound = [:listed, :unclaimed]
    break
  end
end

[true, businessFound]