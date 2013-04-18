url = "http://www.getfave.com/search?q=#{data['businessfixed']}&g=#{data['city']}%2C%20#{data['state_short']}"
page = Nokogiri::HTML(RestClient.get(url))  
thelist = page.css("a.business.result")
if not thelist.length == 0
  subitem = thelist[0]
  if subitem.css("span.name").text =~ /#{data['business']}/
    subpage = Nokogiri::HTML(RestClient.get(subitem["href"]))
      if subpage.css("a#claim").length == 0
        businessFound = [:listed, :unclaimed]    
      else
        businessFound = [:listed, :claimed]        
      end
  else
    businessFound = [:unlisted]
  end  
else
  businessFound = [:unlisted]
end


[true, businessFound]