url = "http://www.local.com/results/?keyword=#{data['businessfixed']}&location=#{data['city']}%252C%2520#{data['state_short']}"

page = Nokogiri::HTML(RestClient.get(url))  
thelist = page.css("div.listBlockL")

thelist.each do |item|

  thelink = item.css("a.txtBlock.item.orgClick")
  #puts(thelink[0].to_s)
  
  next if thelink.to_s == ""
  next if not thelink[0]['href'] =~ /\/business\/details\//i
  
  if thelink.text.to_s =~ /#{data['business']}/i
    
    puts(thelink[0]['href'])
    subpage = Nokogiri::HTML(RestClient.get("http://www.local.com"+thelink[0]['href']))
    if subpage.css("a.blueLink.bold").length == 0
      businessFound = [:listed, :claimed]      
    else
      businessFound = [:listed, :unclaimed]
    end
    
    break
  end  
  businessFound = [:unlisted]
end


STDERR.puts businessFound.inspect
return true, businessFound