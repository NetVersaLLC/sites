url = "http://www.snoopitnow.com/index2.php?sobi2Search=#{data['businessfixed']}&searchphrase=any&field_area=&field_postcode=#{data['zip']}&option=com_sobi2&Itemid=26&no_html=1&sobi2Task=axSearch&sobiCid=0&SobiSearchPage=0&SobiCatSelected_0=0%20HTTP/1.1"

page = Nokogiri::HTML(RestClient.get(url))  

thetable = page.css('table.sobi2Listing')
if thetable.length == 0
  businessFound = [:unlisted]
else
businessFound = [:unlisted]
  thetable.search('table > tr').each do |row|
    thelink = row.css('a')[0]
    next if thelink == nil

    if thelink.text =~ /#{data['business']}/
      businessFound = [:listed, :unclaimed]
      break
    end
  end
end
