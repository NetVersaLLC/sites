require 'rest-client'
require 'nokogiri'

data = {}
data['state_short']		= "TX"
data['business']		= "Pizza By Marco"
data['city']			= "Plano"

#data['businessfixed'] = 

businessFound = {}
url = "http://www.showmelocal.com/local_search.aspx?q=#{CGI.escape(data['business'])}&s=#{data['state_short']}&c=#{data['city']}"
resp = RestClient.get url

nok = Nokogiri::HTML(resp)

businessFound['status'] = :unlisted

nok.css('div.serachresult').each do |result|
	if result.css("a")[0].text =~ /#{data['business']}/i
		businessFound['listed_url']		= "http://www.showmelocal.com/"+result.css("a")[0].attr('href')
		subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
		businessFound['listed_address'] = subpage.xpath("//span[@itempr='streetAddress']").text + ", " + subpage.css("span[@itempr='addressRegion']").text + ', ' + subpage.css("span[@itempr='postalCode']").text
		businessFound['listed_phone']	= subpage.xpath("//span[@itempr='telephone']").text
		businessFound['listed_name']	= subpage.xpath("//span[@itempr='name']").text
		businessFound['status']			= :claimed
		puts subpage
		break
	end


end


#puts resp
 
puts businessFound
[true, businessFound]
