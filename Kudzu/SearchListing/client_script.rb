name=data['business'].gsub(" ","%20").gsub("'","%27")
city=data['city']
state=data['state_short']
zip=data['zip']
url="http://www.kudzu.com/controller.jsp?N=0&searchVal=#{name}&currentLocation=#{city}%2C%20#{state}%20#{zip}&searchType=keyword&Ns=P_PremiumPlacement"
businessFound = {}
businessFound['status'] = :unlisted
name=data['business'].gsub("%20"," ").gsub("%27","'")
nok = Nokogiri::HTML(RestClient.get url)
nok.css("div.nvrBox").each do |bi|
        if (bi.css("h3.nvrName a").text) =~ /#{name}/i
            businessFound['listed_name'] = bi.css("h3.nvrName a").text
            businessFound['listed_address'] = bi.css("div.nvrAddr").text            
            businessFound['listed_url'] = "http://www.kudzu.com/"+bi.css("h3.nvrName a").attr("href")
            puts businessFound['listed_url']
            subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
            if subpage.xpath("//a[@class='topNavLink']").length > 0
                businessFound['status'] = :listed                
            else
                businessFound['status'] = :claimed
            end        
            businessFound['listed_phone'] = subpage.search("span.tel").text            
            businessFound['listed_phone'] = businessFound['listed_phone'].gsub("(","")
            businessFound['listed_phone'] = businessFound['listed_phone'].gsub(") ","-")            
            break
        end
end
[true, businessFound]