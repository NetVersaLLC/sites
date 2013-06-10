query = data['city'].gsub(" ", "-") + "-" + data['state'].gsub(" ", "-")
query = query.downcase
url = "http://tupalo.com/en/search?q=Starbucks&city_slug=#{query}"
nok = Nokogiri::HTML(RestClient.get url)
businessFound = {}
businessFound['status'] = :unlisted
nok.css("div.title").each do |resultBlock|
  if resultBlock.xpath("//span[@itemprop='name']")[0].text =~ /#{data['business']}/i
    businessFound['listed_url'] = resultBlock.css("a")[0].attr("href")
    businessFound['listed_address'] = resultBlock.xpath("//span[@itemprop='streetAddress']")[0].text + ", " + resultBlock.xpath("//span[@itemprop='addressLocality']")[0].text + ", " + resultBlock.xpath("//span[@itemprop='postalCode']")[0].text
    puts businessFound['listed_url']
    subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])    
    businessFound['listed_phone'] = subpage.xpath("//span[@itemprop='telephone']")[0].text
    if subpage.xpath("//span[contains(text(), 'Is this your business?')]").length > 0
      businessFound['status'] = :listed
    else
      businessFound['status'] = :claimed
    end

    break
  end

end

[true, businessFound]