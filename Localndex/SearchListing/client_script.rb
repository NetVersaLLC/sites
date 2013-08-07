name=data['business'].gsub(" ","+").gsub("'","%27")
city=data['city'].gsub(" ","+")
state=data['state_short']
url = "http://www.localndex.com/results.aspx?wht=#{name}&whr=#{city}%2c+#{state}"
name = name.gsub("+"," ").gsub("%27","'")
nok = Nokogiri::HTML(RestClient.get url)
businessFound = {}
businessFound['status'] = :unlisted
if nok.css("span.Verdana16 a").text =~ /#{name}/i   
  businessFound['listed_name'] = nok.css("span.Verdana16 a").text
  businessFound['listed_url'] = nok.css("a#ctl00_MainContentPlaceHolder_repRegListing_ctl00_wucRegListing_lnkRegBusName").attr("href").value
  zip=nok.css("span#ctl00_MainContentPlaceHolder_repRegListing_ctl00_wucRegListing_lblRegBusZip").text
  businessFound['listed_address'] = nok.css("span#ctl00_MainContentPlaceHolder_repRegListing_ctl00_wucRegListing_lblRegBusAddress").text
  businessFound['listed_address'] = businessFound['listed_address'] +" " +city+", "+state + " "+ zip
  businessFound['listed_phone'] = nok.css("span#ctl00_MainContentPlaceHolder_repRegListing_ctl00_wucRegListing_lblRegBusPhone").text.gsub("(","").gsub(") ","-")
  businessFound['status'] = :claimed
end
[true, businessFound]