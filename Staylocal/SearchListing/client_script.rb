businessFound = [:unlisted]

url = "http://www.staylocal.org/search/node/#{data['businessfixed']}%20type:business_listing"
puts(url)
html = RestClient.get url
nok = Nokogiri::HTML(html)

nok.css("dt.title").each do |item|

	puts(item.css("a")[0].text)

	if item.css("a")[0].text == data['businss']
		businessFound = [:listed,:claimed]
		break
	end

end

[true, businessFound]