name=data['business'].gsub(" ","+")
city=data['city']
state=data['state_short']
zip=data['zip']
url="http://www.bizzspot.com/results?query=#{name}&Submit=submit"
puts url
businessFound = {}
businessFound['status'] = :unlisted
name=data['business'].gsub("+"," ")
nok = Nokogiri::HTML(RestClient.get url)
nok.css("div.search_result").each do |bi|
    if (bi.css("h2.color_black a").text) =~ /#{name}/i
            businessFound['listed_name'] = bi.css("h2.color_black a").text
            address=bi.css("h2.color_black").text.gsub(",","")
            a1=address.split("-")[1]
            businessFound['listed_url'] = "http://www.bizzspot.com/"+bi.css("h2.color_black a").attr("href")
            subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
            businessFound['listed_address'] = subpage.css("span.street-address").text + a1
            businessFound['listed_phone'] = subpage.css("div.tel").text.gsub("(","").gsub(")","").gsub("-"," ")
            if subpage.xpath("//span[@class='street-address']").length > 0
                businessFound['status'] = :claimed
            else
                businessFound['status'] = :listed
            end
            break
        end
end
[true, businessFound]

puts(businessFound)