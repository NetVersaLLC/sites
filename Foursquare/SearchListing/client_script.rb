businessFixed = data['business'].gsub(" ","%20")
businessFound = {}
url = "http://foursquare.com/explore?near=#{data['zip']}&q=#{businessFixed}"
puts (url)
page = Nokogiri::HTML(RestClient.get(url))


#puts page
found = false
page.css("div.venueBlock").each do |venue|
	if venue.css("div.venueName").text =~ /#{data['business']}/
		found = true
		businessFound['listed_name'] 	= venue.css("div.venueName").text
		businessFound['listed_url'] 	= venue.css("div.venueName a")[0].attr("href")

		puts businessFound['listed_url']
		subpage = Nokogiri::HTML(RestClient.get(businessFound['listed_url']))
		businessFound['listed_address'] = subpage.css("span.street-address").text + ", " + subpage.css("span.locality").text + subpage.css("span.region").text + ", " +subpage.css("span.postal-code").text
		businessFound['listed_phone']	= subpage.css("span.tel").text
		puts subpage.search "[text()*='Claim it now.']"
		if subpage.search "[text()*='Claim it now.']"
			businessFound['status'] = :claimed
			#currently no was to tell if claimed or unclaimed
		else
			businessFound['status'] = :claimed
		end
		break
	end
end

	if not found
		businessFound['status'] = :unlisted
	end


[true,businessFound]

