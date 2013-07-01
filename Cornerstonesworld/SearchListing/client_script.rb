#replace & with and
def replace_and(business)
  return business.gsub("&","and")
end

url = "http://www.cornerstonesworld.com/en/directory/country/USA/state/#{data['state']}/keyword/#{CGI.escape(data['business'])}/new"

page = Nokogiri::HTML(RestClient.get url)
businessFound = {}
page.css("td.dirlisttext").each do |item|

if item.nil?
  businessFound['status'] = :unlisted
  else
  if replace_and(item.css("span.titlesmalldblue").text.gsub(/\t+|\n+/, '') .strip) =~ /#{replace_and(data['business'])}/i
    businessFound['status'] = :listed
    businessFound['listed_name'] = item.css("span.titlesmalldblue").text # Return business name given on webpage
    businessFound['listed_address'] = item.search("//p")[1].text.gsub(/\t+/, '') .strip
    businessFound['listed_phone'] = item.search("//p")[2].text.gsub(/[\x80-\xff]|\n+|\t+|[a-zA-Z]|\:/,'')
    businessFound['listed_url'] = url
  end
  end
end

[true, businessFound]
