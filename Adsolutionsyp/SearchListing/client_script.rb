#require 'nokogiri'
#require 'rest-client'


#data = {}
#data['business']		= "Netversa"
#data['city']			= "Irvine"
#data['state']			= "CA"

data['business-fixed']	= data['business'].gsub(" ", "-")
data['city-fixed']		= data['city'].gsub(" ", "-")
data['state-fixed']		= data['state'].gsub(" ", "-")
data['city-state']		= data['city-fixed'] + "-" + data['state-fixed']


url = "http://www.yellowpages.com/#{data['city-state']}/#{data['business-fixed']}"
business_found = {}
business_found['status']	= :unlisted
search_results = Nokogiri::HTML(RestClient.get url)

search_results.css("div.listing-content").each do |result|
	if result.css("a.url").text =~ /#{data['business']}/i
		sub_url = result.css("a.url").attr("href")
		puts sub_url

		sub_page = Nokogiri::HTML(RestClient.get sub_url.text)
		business_found['listed_name'] 		= result.css("a.url").text
		business_found['listed_url'] 		= sub_url.text
		business_found['listed_address'] 	= sub_page.css("span.listing-address").text.gsub(/\n/, " ").strip
		business_found['listed_phone'] 		= sub_page.css("p.phone").text.gsub(/\n/, " ").strip
		# Only way to "claim" the business is to pay them money.
		business_found['status'] 			= :claimed
		break
	end

end

#puts business_found
[true, business_found]