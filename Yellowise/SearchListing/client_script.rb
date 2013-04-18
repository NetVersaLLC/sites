url = "http://www.yellowise.com/results/#{data['citystate']}/#{data['businessfixed']}"

page = Nokogiri::HTML(RestClient.get(url))  
thelist = page.css("div#block-block-25")

if thelist.css("div.search-item").length == 0
  businessFound = [:unlisted]
else
  
  businessFound = [:unlisted]
  thelist.css("div.search-item").each do |item|
      puts(item.css("a[2]").to_s)    
      if item.css("a[2]").text =~ /#{data['business']}/i
          thelink = item.css("a[2]")
          thelink = thelink[0]['href']  
          subpage = Nokogiri::HTML(RestClient.get(thelink))  
          if subpage.css("span#claimbuttonText").length == 0
            businessFound = [:listed, :claimed]
          else
            businessFound = [:listed, :unclaimed]
          end
          break
      end                 
  end    
 
end
  
[true,businessFound]