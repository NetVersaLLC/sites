url = "http://www.expressbusinessdirectory.com/businesses/#{data['businessfixed']}/"
page = Nokogiri::HTML(RestClient.get(url)) 
businessFound = {}
businessFound['status'] = :unlisted
page.css("a#ctl00_ContentPlaceHolder1_dlResults_ctl00_hypBusiness").each do |resultLink|
	if resultLink.text =~ /#{data['business']}/i
		businessFound['status'] = :claimed
		businessFound['listed_url'] = resultLink.attr("href")
		businessFound['listed_address']	= page.css("span#ctl00_ContentPlaceHolder1_dlResults_ctl00_lblAddress").text
	end

end


[true, businessFound]