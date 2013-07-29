#Replace '&' with 'and'
def replace_and(business)
  return business.gsub("&","and")
end



url = "https://www.getfave.com/search?q=#{CGI.escape(data['business'])}&g=#{CGI.escape(data['zip'])}"
businessFound = {}
page = Nokogiri::HTML(RestClient.get(url))

if page.text.include? "We couldn't find any matches."
  businessFound['status'] = :unlisted
else
  page.xpath("//div[@id='business-results']/a").each do |item|
    if replace_and(item.css('span.name').text) =~ /#{replace_and(data['business'])}/i
      businessFound['listed_name'] = item.css('span.name').text
      businessFound['listed_address'] = item.css('span.address').text
      businessFound['listed_url'] = item.attr('href')

      nok = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
      businessFound['listed_phone'] = nok.css("phone-number")[0].text
      if nok.css("a#claim").length > 0
        businessFound['status'] = :listed
      else
        businessFound['status'] = :claimed
      end
      break
    end
  end
end

[true, businessFound]
