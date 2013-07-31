

# COPY AND PASTE THE CONTENTS OF SearchListing/client_script.rb here

name=data['name']
city=data['city']
url="http://www.showmelocal.com/local_search.aspx?q=#{name}&s=ga&c=#{city}"
businessFound = {}
businessFound['status'] = :unlisted
name=data['name'].gsub("+"," ")
nok = Nokogiri::HTML(RestClient.get url)
nok.css("table#dgBusiness").each do |bi|   
        if (bi.css("div.h a").text) =~ /#{name}/i                                 
            businessFound['listed_name']    = bi.css("div.h a").text
            businessFound['listed_url']     = "http://www.showmelocal.com/"+ bi.css("div.h a").attr("href")
            businessFound['listed_address'] = bi.css("div.address").text
            subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])            
            businessFound['listed_phone']   = subpage.css("span#_ctl5_lblPhoneNumber").text.gsub("(","").gsub(")","-")
            businessFound['status'] = :claimed
            break
        end
end

#######
###



[true, businessFound]