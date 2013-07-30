#require 'nokogiri'
#require 'rest-client'

#data = {}
#data['business']    = "Pizza By Marco"
#data['city']        = "Plano"
#data['state_short'] = "TX"

#replace & with and
def replace_and(business)
  return business.gsub("&","and")
end

url = "http://www.insiderpages.com/search/search?query=#{CGI.escape(data['business'])}&location=#{CGI.escape(data['city']+ ' ,' + data['state_short'])}&commit=Go!"

nok = Nokogiri::HTML(RestClient.get url)

businessFound = {}

if nok.text.include?('There were 0 results')
  businessFound['status'] = :unlisted
  else
  nok.xpath("//div[@class='content search_result search_result_clickable clearfix']").each do |bi|
  if replace_and(bi.css('h2').text.gsub(/\n+/,'').strip) =~ /#{replace_and(data['business'])}/i
    businessFound['listed_name'] = bi.css('h2').text.gsub(/\n+/,'').strip
    businessFound['listed_url'] = "http://www.insiderpages.com"+bi.css("h2 a").attr("href")
    businessFound['listed_address'] = bi.css('div.sub_header').text.gsub(/\n+/,'').strip
    subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
    businessFound['listed_phone'] = subpage.xpath("//div[@class='bizCardInfo bottom-shadow']/p").text
    businessFound['status'] = :claimed
    break
    end
  end
end
#puts businessFound
[true, businessFound]
