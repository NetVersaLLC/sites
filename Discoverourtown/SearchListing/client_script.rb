businessfixed = data['business'].gsub(" ", "+") + "+" + data['zip']
url = "http://www.google.com/cse?cx=partner-pub-9905764502590625%3Anky1c6v46yv&cof=FORID%3A11&q=#{businessfixed}&sa=Search&ad=n9&num=10"

page = Nokogiri::HTML(RestClient.get(url)) 
businessFound = {}
businessFound['status'] = :unlisted

page.css("a").each do |resultLink|
	next if not resultLink.attr("href") =~ /http:\/\/www.discoverourtown.com\//
	puts resultLink.text
	if resultLink.text =~ /#{data['business']}/i
		businessFound['status'] = :claimed
		businessFound['listed_url'] = resultLink.attr('href')

		subpage = page = Nokogiri::HTML(RestClient.get(businessFound['listed_url'])) 
		businessFound['listed_address'] = subpage.css("span.WEBaddr").text
		break
	end
end

[true,businessFound]