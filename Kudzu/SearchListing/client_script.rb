require 'rubygems'
require 'nokogiri'
require 'open-uri'
#name=data['name'].gsub("-","%20")
name=data['name'].gsub(" ","%20")
puts name
zip=data['zip']
puts zip
cityfixed = data['city'].gsub(" ", "%20")
statenamefixed = data['state']#.gsub(" ", "+")

#http://www.kudzu.com/controller.jsp?N=0&searchVal=Cummings&currentLocation=Mesa%2C%20AZ%2085205&searchType=keyword&Ns=P_PremiumPlacement
#burl = "http://www.kudzu.com/"
#url="#{burl}controller.jsp?N=0&searchVal=#{name}&currentLocation=#{cityfixed}%2C%20#{statenamefixed}%20#{zip}&searchType=keyword&Ns=P_PremiumPlacement"
url="http://www.kudzu.com/controller.jsp?N=0&searchVal=bridge%20stone&currentLocation=Raleigh%2C%20NC%2027607&searchType=keyword&Ns=P_PremiumPlacement"
puts(url)
nok = Nokogiri::HTML(RestClient.get url)
name=data['name']
puts ("Test message")
#puts(nok)
businessFound = {}
businessFound['status'] = :unlisted

    nok.css("div.nvrBox").each do |bi|
        if (bi.css("h3.nvrName a").text) =~ /yellow dot heating & air conditioning/i#/#{name}/i
            businessFound['listed_name'] = bi.css("h3.nvrName a").text # Return business name given on webpage
            businessFound['listed_address'] = bi.css("div.nvrAddr").text
            #businessFound['listed_phone'] = bi.css("div.phone").text.gsub(/\n+/,'')
            businessFound['listed_url'] = "http://www.kudzu.com/"+bi.css("h3.nvrName a").attr("href")
            puts businessFound['listed_url']
            subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
            if subpage.xpath("//a[@class='topNavLink']").length > 0
                businessFound['status'] = :listed
            else
                businessFound['status'] = :claimed
            end        
                puts("Business found.")
            break
        end
    end

[true, businessFound]