name=data['business']
city=data['city']
name=CGI.escape name
url= "http://www.showmelocal.com/local_search.aspx?q=#{name}&s=#{data['state_short'].downcase}&c=#{city.downcase}"
businessFound = {}
businessFound['status'] = :unlisted
nok = Nokogiri::HTML(RestClient.get url)
nok.css("div.serachresult").each do |bi|
        if (bi.css("div.h a").text) =~ /#{data['business']}/i                                 
            businessFound['listed_name']    = bi.css("div.h a").text
            businessFound['listed_url']     = "http://www.showmelocal.com/"+ bi.css("div.h a").attr("href")
            businessFound['listed_address'] = bi.css("div.address").text
            subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])            
            businessFound['listed_phone']   = subpage.css("span#_ctl5_lblPhoneNumber").text.gsub("(","").gsub(")","-")
            businessFound['status'] = :claimed
            break
        end
end
[true, businessFound]
puts(businessFound)