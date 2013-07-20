url = "http://search.businessdb.com/?q=#{CGI.escape(data['business'])}&c=#{CGI.escape('United States of America')}"

businessFound = {}
page = Nokogiri::HTML(RestClient.get(url))

if page.text.include? "did not match with any companies"
  businessFound['status'] = :unlisted
else
  page.xpath("//div[@class='search-results']/ul/li").each do |item|
    if item.css('a.list-by-1-title').text =~ /#{data['business']}/
      businessFound['status'] = :listed
      businessFound['listed_name'] = item.css('a.list-by-1-title').text.delete("\t\r\n")
      businessFound['listed_url'] = item.css('a.list-by-1-web').text
      break
    end
  end
end

[true, businessFound]