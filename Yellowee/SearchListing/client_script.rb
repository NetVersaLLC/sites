def replace_and(business)
  return business.gsub("&","and")
end

businessfixed         = data[ 'business' ].gsub(" ", "+")
cityfixed = data['city'].gsub(" ", "+")
statenamefixed = data['state'].gsub(" ", "+")
businessFound = {}

url = "http://www.yellowee.com/search?what=#{businessfixed}&where=#{cityfixed}%2C+#{statenamefixed}%2C+United+States"
puts url
nok = Nokogiri::HTML(RestClient.get url)


businessFound['status'] = :unlisted
nok.css("div.business_info").each do |bi|
if replace_and(bi.css("div.title a").text) =~ /#{replace_and(data['business'])}/i
	businessFound['listed_name'] = bi.css("div.title a").text # Return business name given on webpage
        businessFound['listed_address'] = bi.css("div.address_num_name").text.gsub(/\n+/,'') + ", " + bi.css("div.address_city_state").text.gsub(/\n+/,'')
        businessFound['listed_phone'] = bi.css("div.phone").text.gsub(/\n+/,'')
        businessFound['listed_url'] = "http://www.yellowee.com/"+bi.css("div.title a").attr("href")
puts businessFound['listed_url']
        subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
        if subpage.xpath("//a[@title='Claim Business']").length > 0
            businessFound['status'] = :listed
        else
            businessFound['status'] = :claimed
        end
        break
    end
end



[true, businessFound]
