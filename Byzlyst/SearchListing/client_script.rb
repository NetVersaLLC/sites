businessFound = {}
url = "http://byzlyst.com/?s=#{CGI.escape(data['business'])}&cat="
page = Nokogiri::HTML(RestClient.get(url))
if page.at_xpath("//a[text()='#{data['business']}']")
	businessFound['status'] = :claimed
	businessFound['listed_name'] = page.at_xpath("//a[text()='#{data['business']}']").text
	businessFound['listed_url'] = page.at_xpath("//a[text()='#{data['business']}']/@href").to_s
else
	businessFound['status'] = :unlisted
end

[true, businessFound]