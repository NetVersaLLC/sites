def replace_and(business)
  return business.gsub("&","and")
end

data['cityfixed'] = data['city'].gsub(" ","-")
data['businessfixed'] = data['business'].gsub(" ","-").gsub(" & ","").gsub(",","")

url = "http://www.merchantcircle.com/search?q=#{data[ 'businessfixed' ]}&qn=#{data['cityfixed']}"

begin
  businessFound = {}
  page = Nokogiri::HTML(RestClient.get(url))

  page.css("div.resultWrapper").each do |item|
    if replace_and(item.at_css("h3").text) =~ /#{replace_and(data['business'])}/
      businessFound['status'] = :listed
      businessFound['listed_name'] = item.at_css("h3").text # Return business name given on webpage
      address = item.css('span[@itemprop="streetAddress"]').text + " " + item.css('span[@itemprop="addressLocality"]').text + " " + item.css('span[@itemprop="postalCode"]').text
      businessFound['listed_address'] = address
      businessFound['listed_phone'] = item.css('span[@itemprop="telephone"]').text
      businessFound['listed_url'] = item.at_css("a").attr('href')
      if not businessFound['listed_url'].nil?
        subpage = Nokogiri::HTML(RestClient.get(businessFound['listed_url']))
        claimLink = subpage.css("span").text
        if claimLink.length == 0
          businessFound['status'] = :claimed
        else
          businessFound['status'] = :listed
        end
      end
    end
   end
rescue
  businessFound['status'] = :unlisted
end

[true, businessFound]