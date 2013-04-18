begin #If there are no listings found the site redirects the user to a 404 page. Since it returns 404 RestClient treates it as an exception. 
html = RestClient.get "http://www.kudzu.com/controller.jsp?", { :params => { :N => "0", :searchVal => data['businessfixed'], :currentLocation => data['zip'], :searchType => 'keyword', :Ns => "P_PremiumPlacement", :distFilter => "10" } }
page = Nokogiri::HTML(html)  

rescue RestClient::ResourceNotFound
  businessFound = [:unlisted]
  it404ed = true
end

if not it404ed
page.css("a.results_recordname").each do |link|
  
  if link.text == data['business']
    thelink = "http://www.kudzu.com"+link.attribute("href")
    subpage = Nokogiri::HTML(RestClient.get(thelink))
    if subpage.xpath('//span[contains(text(), "Claim This Profile!")]')
      businessFound = [:listed, :unclaimed]
    else
      businessFound = [:listed, :claimed]
    end
  break
  end
end
end


[true, businessFound]