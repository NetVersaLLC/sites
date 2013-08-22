#Written by Kazyyk, 7/28/13
data['businessfixed'] = data['business'].gsub(" ","+").gsub(",","%2C").gsub("&","%26").gsub("'","%27")

businessFound = {}

url = "https://www.facebook.com/search.php?q=#{data['businessfixed']}"
page = Nokogiri::HTML(RestClient.get(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
found = false
page.css("div#pagelet_search_results").css("div.mbm.detailedsearch_result").each do |resultdiv|
  next if not resultdiv.at_css('div.fsm.fwn.fcg') #Skip personal pages
  if resultdiv.text.include? data['business']
    resultlink = resultdiv.at_css("div.instant_search_title.fsl.fsl.fwb.fcb a")
    found = true
    businessFound['status'] = :claimed
    businessFound['listed_url'] = resultlink["href"]
    businessFound['listed_name'] = resultlink.text
    break
  else
    #Do nothing
  end
end

if not found == true then
  businessFound['status'] = :unlisted
end

[true, businessFound]
