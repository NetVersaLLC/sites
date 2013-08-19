#require 'nokogiri'
#require 'rest-client'
#require 'awesome_print'


#data = {}
#data['business']	= "Take Five Coffee Bar"
#data['zip']			= "66224"

businessFixed = CGI.escape data['business']

url = "http://www.city-data.com/bs/?q=Take+Five+Coffee+Bar&w=#{data['zip']}"

nok = Nokogiri::HTML(RestClient.get url)
businessFound = {}
businessFound['status'] = :unlisted
nok.css("div.bs_item").each do |result|
	if result.css("h3").text =~ /#{data['business']}/i
		businessFound['listed_address'] 	= result.at('div:contains("Address: ")').text.delete("Address:") + ", " + result.at('div:contains("City:")').text.delete("City: ")
		businessFound['listed_phone'] 		= result.at('div:contains("Phone: ")').text.delete("Phone:")
		businessFound['listed_url']			= url
		businessFound['listed_name']		= data['business']
		businessFound['status']				= :claimed
	end
end

#ap businessFound
[true, businessFound]