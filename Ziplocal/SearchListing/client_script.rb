businessfixed = data['business'].gsub(" ", "%20")
url = "http://www.ziplocal.com/list.jsp?lang=0&nt=N&na=#{businessfixed}&ct=#{data['zip']}"
nok = Nokogiri::HTML(RestClient.get url)
businessFound = {}
businessFound['status'] = :unlisted
nok.css("div.listing.vcard.cfix").each do |resultBlock|
  if resultBlock.css("a.url")[0].text =~ /#{data['business']}/i
    businessFound['listed_address'] = resultBlock.css("span.street-address").text + ", " + resultBlock.css("span.locality").text + ", " + resultBlock.css("span.region").text
    businessFound['listed_url'] = "http://www.ziplocal.com/"+resultBlock.css("a.url")[0].attr('href')
    businessFound['listed_phone'] = resultBlock.css("p.tel").text   
    subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
    if subpage.xpath("//a[contains(text(), 'Update')]").length > 0
      businessFound['status'] = :claimed
      #Claimed listings show the same links
    else
      businessFound['status'] = :claimed
    end
    break
  end


end

[true,businessFound]