name=data['business'].gsub(" ","+").gsub("'","%27")
city=data['city'].gsub(" ","+")
state=data['state_short']
url = "http://tupalo.com/en/search?q=#{name}&city_select=#{city}%2C+#{state}"
name = name.gsub("+"," ").gsub("%27","'")
nok = Nokogiri::HTML(RestClient.get url)
businessFound = {}
businessFound['status'] = :unlisted
nok.css("div.title").each do |resultBlock|  
  if resultBlock.xpath("//span[@itemprop='name']")[0].text =~ /#{name}/i    
    businessFound['listed_name'] = resultBlock.xpath("//span[@itemprop='name']")[0].text # Return business name given on webpage
    businessFound['listed_url'] = resultBlock.css("a")[0].attr("href")
    businessFound['listed_address'] = resultBlock.xpath("//span[@itemprop='streetAddress']")[0].text + ", " + resultBlock.xpath("//span[@itemprop='addressLocality']")[0].text + ", " + resultBlock.xpath("//span[@itemprop='postalCode']")[0].text
    subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
    businessFound['listed_phone'] = subpage.xpath("//span[@itemprop='telephone']")[0].text
    if subpage.css("span.al.button.small.color.green").length > 0
      businessFound['status'] = :listed
    else
      businessFound['status'] = :claimed
    end
    break
  end
end
[true, businessFound]