name=data['name']
zip=data['zip']
url="http://www.usyellowpages.com/find/?BoundaryType=1&Where=#{zip}&What=#{name}&x=22&y=11"
puts(url)
businessFound = {}
businessFound['status'] = :unlisted
name=data['name'].gsub("+"," ")
nok = Nokogiri::HTML(RestClient.get url)
nok.css("table.sortable").each do |bi|   
        if (bi.css("td.SearchResultAddy a").text) =~ /#{name}/i                                 
            businessFound['listed_name']    = name
            businessFound['listed_url']     = "http://www.usyellowpages.com"+bi.css("td.SearchResultAddy a").attr("href")            
            subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])            
            businessFound['listed_address'] = subpage.css("span.RL.HBC span#address").text.split(",")[0] + ", " + businessFound['listed_url'].split("/")[5] + ", #{zip}"
            businessFound['listed_phone']   = subpage.css("span.RL.HBC span.BookPhone").text.gsub("(","").gsub(") ","-")
            businessFound['status'] = :claimed
            break
        end
end


[true, businessFound]

puts(businessFound)