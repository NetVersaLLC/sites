name=data['name']
city=data['city']
state=data['state']
url="http://www.yellowwiz.com/Business_Listings.php?name=#{name}&city=#{city}&state=#{state}&current=1&Submit=Search"
businessFound = {}
businessFound['status'] = :unlisted
name=data['name'].gsub("+"," ")
cost=0
nok = Nokogiri::HTML(RestClient.get url)
    nok.css("table.vc_result").each do |bi|    	
        if (bi.css("span a").text) =~ /#{name}/i #/yellow dot heating & air conditioning/i
            businessFound['listed_name'] = bi.css("span a").text # Return business name given on webpage
            businessFound['listed_address'] = bi.css("span.cAddText").text
            businessFound['listed_phone'] = bi.css("font").text.gsub(/\n+/,'')
            businessFound['listed_url'] = "http://www.yellowwiz.com/"+bi.css("span a").attr("href")
            puts businessFound['listed_url']
            puts businessFound['listed_phone']
            businessFound['status'] = :listed
            cost=1
            break
        end
    end
    if cost == 1
    	puts "Business is Listed"
    else
    	puts "Business is not listed. Please note that it takes 3 business days for new business at Yellowwiz to be listed."
    end    
[true, businessFound]
