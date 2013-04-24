url = "http://www.usyellowpages.com/find/?BoundaryType=1&Where=#{data['zip']}&What=#{data['businessfixed']}"
page = Nokogiri::HTML(RestClient.get(url)) 

if not page.css("td.SearchResultAddy").length == 0
 	businessFound = [:unlisted]	
 	page.css("td.SearchResultAddy").each do |item|

 		if item.css("a").text =~ /#{data['business']}/i
 			businessFound = [:listed, :claimed]
 		end
 	end
else
  businessFound = [:unlisted]
end
