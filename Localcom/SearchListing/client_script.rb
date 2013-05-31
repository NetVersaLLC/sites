url = "http://www.local.com/business/results/?keyword=#{CGI.escape(data['business'])}&location=#{CGI.escape(data['city'] + ', ' + data['state_short'])}"

businessFound = {'status' => :unlisted} 

page = Nokogiri::HTML(RestClient.get(url)) 

thelist = page.css(".courtesyListing")

thelist.each do |item|
  thelink = item.css("a.txtBlock.item.orgClick")

  next if thelink.to_s == ""
  next if not thelink[0]['href'] =~ /\/business\/details\//i
  
  if thelink.text.to_s =~ /#{data['business']}/i
    businessFound['status'] = :listed

    street_addr = item.css('.street-address.fl').text.strip
    loc_addr = item.css('.locality.region.fl').text.strip
    businessFound['listed_address'] = street_addr + loc_addr
    businessFound['listed_phone'] = item.css('.phoneNumber.tel').text.strip 

    link = "http://www.local.com"+thelink[0]['href']
    businessFound['listed_url'] = link
    subpage = Nokogiri::HTML(RestClient.get(link))
    if subpage.css("a.blueLink.bold").length == 0
      businessFound['status'] = :unclaimed      
    else
      businessFound['status'] = :claimed
    end
    
    break
  end  
  
end


STDERR.puts businessFound.inspect
[true, businessFound]
