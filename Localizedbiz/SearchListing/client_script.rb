businessFound = {}

businessfixed        = data['business'].gsub(" ", "+")
url = "http://www.localizedbiz.com/search.php?q=#{businessfixed}"
page = Nokogiri::HTML(RestClient.get(url)) 
if page.css("a.biz_title").length > 0
	page.css("a.biz_title").each do |resultLink|
		if 	resultLink.text =~ /#{data['business']}/i
			businessFound['status'] = :claimed
			businessFound['listed_address']	= page.css("td.biz_address")[0].text
			businessFound['listed_url'] = resultLink.attr('href')
			businessFound['listed_phone'] = page.css("td.biz_phone")[0].text
		end
	end

else
	businessFound['status']		= :unlisted
end
[true, businessFound]