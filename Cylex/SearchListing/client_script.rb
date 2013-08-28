businessFound = {}

url = "http://www.cylex-usa.com/s?q=#{CGI.escape(data['business'])}&c=#{CGI.escape(data['city'])}&p=1"
page = Nokogiri::HTML(RestClient.get(url))

page.css('a').each do |link|
  if link.text == data['business']
    businessFound['status'] = :listed
    business_page = Nokogiri::HTML(RestClient.get(link['href']))

    businessFound['listed_address'] = business_page.css("address").text
    businessFound['listed_url'] = business_page.css('a.url').text
    businessFound['listed_phone'] = business_page.xpath("//span[@itemprop='telephone']").text
    businessFound['listed_name'] = business_page.css("h2.firmaname").text
    break
  else
    businessFound['status'] = :unlisted
  end
end

[true, businessFound]