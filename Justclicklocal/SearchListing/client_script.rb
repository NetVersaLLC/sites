#Written by Kazyyk, 7/25/13
data['cityfixed'] = data['city'].gsub(" ","-")
data['businessfixed'] = data['business'].gsub(" ","-").gsub(" & ","").gsub(",","")

url = "http://www.justclicklocal.com/citydir/#{data[ 'cityfixed' ]}-#{data[ 'state' ]}--#{data[ 'businessfixed' ]}.html"
puts(url)
page = Nokogiri::HTML(RestClient.get(url)) 
if page.css("ol.initial-results") #Do results even exist?
  result = page.at_xpath('//*[@id="r"]/div[2]/div[1]/ol[1]/li[1]/div[2]/a').text #Grab first result
  if result == data[ 'business' ] #Match results, otherwise assume unlisted
    businessFound['status'] = :listed
    puts("Business is listed")
    businessFound['listed_address'] = page.at_css("span.address").text
    puts("Listed Address: " + businessFound['listed_address'])
    businessFound['listed_phone'] = page.at_css("span.phone-num").text
    puts("Listed Phone: " + businessFound['listed_phone'])
  else
    puts("Business is unlisted")
    businessFound['status'] = :unlisted
end



[true, businessFound]
end