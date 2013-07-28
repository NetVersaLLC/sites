
data[ 'citystate' ]          = data[ 'city' ] + ", " + data[ 'state' ]
data[ 'businessfixed' ]     = data['business'].gsub(" ", "%20")

url = "http://www.yellowassistance.com/frmBusResults.aspx?nas=a&nam=#{data['businessfixed']}&cas=r&cat=#{data['businessfixed']}&mis=a&mil=&zis=a&zip=#{data['zip']}&cis=r&cit=#{data['city']}&sts=r&sta=#{data['state']}&typ=bus&set=a&myl=&slat=&slon="
puts url
page = Nokogiri::HTML(RestClient.get(url))  
thelist = page.css("td.Verdana12 a")
businessFound = {}
businessFound['status'] = :unlisted
thelist.each do |item|
  next if not item.text =~ /#{data['business']}/i  
  thelink = "http://www.yellowassistance.com/"+item['href']
  subpage = Nokogiri::HTML(RestClient.get(thelink))  

  businessFound['listed_url']       = thelink
  businessFound['listed_name']      = subpage.css("span#lblTitle").text
  businessFound['listed_address']   = subpage.css("span#lblAddress").text
  businessFound['listed_phone']     = subpage.css("span#lblPhone").text

  if subpage.css("a#lnkListing").length == 0
    businessFound['status'] = :claimed
    break
  else
    
    businessFound['status'] = :listed
    break
  end
end
#puts businessFound
[true, businessFound]