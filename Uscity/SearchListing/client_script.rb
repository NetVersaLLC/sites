#Search for business
citystate = data['city']+ ", " + data['state_short']

businessFound = {}

businessfixed = data['business'].gsub(" ", "-")
citystatefixed = citystate.gsub(", ","-")

url = "http://uscity.net/#{citystatefixed}/#{businessfixed}"

page = Nokogiri::HTML(RestClient.get(url)) 
page.css("div.boxborder").each do |link|	
  if link.text =~ /#{data['business']}/i
    link.css('div.addressbox').map { |info| 
      businessFound['listed_address'] = info.css("strong").text
      businessFound['listed_phone'] = info.css("span.greentxt").text
    }
    link.css('h3 a').map { |info| 
      businessFound['url'] = info['href']
    }
    businessFound['status'] = :claimed
  else
    businessFound['status']	= :unlisted
  end
end

[true, businessFound]
