url = "http://www.thumbtack.com/search?pagenum=1&keyword=#{CGI.escape(data['business'])}&location=#{data['zip']}"
puts url
businessFound = {}
page = Nokogiri::HTML(RestClient.get(url))

businessFound['status'] = :unlisted
if page.text.include? "did not match with any companies"
  businessFound['status'] = :unlisted
else
  page.xpath("//div[@class='pod pod-primary pod-segmented']/ul/li").each do |item|
    if item.css('a').text =~ /#{data['business']}/
      businessFound['status'] = :listed
      listing_page = Nokogiri::HTML(RestClient.get("http://www.thumbtack.com" + item.xpath('//h3/a/@href').first.value))

      businessFound['listed_name'] = listing_page.css('div.profile-meta h2').text.delete("\t\r\n").strip
      businessFound['listed_address'] = listing_page.css('div.profile-meta p.location').text.gsub("(map)", "").delete("\t\r\n").strip
      businessFound['listed_url'] = listing_page.xpath("//span[@class='value']").text
      businessFound['listed_phone'] = listing_page.css('a.website').text
      break
    end
  end
end

[true, businessFound]