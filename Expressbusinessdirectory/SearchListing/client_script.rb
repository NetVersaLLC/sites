def format_business(business)
  business_formatted = business.gsub(' ', '-')
  return business_formatted.gsub('&', '')
end

data[ 'businessfixed' ] = format_business(data['business'])

url = "http://www.expressbusinessdirectory.com/businesses/#{data[ 'businessfixed' ] }"+"-"+data['zip']+"/"
puts(url)

page = Nokogiri::HTML(RestClient.get(url))
businessFound = {}
businessFound['status'] = :unlisted
page.css("a#ctl00_ContentPlaceHolder1_dlResults_ctl00_hypBusiness").each do |resultLink|
  if resultLink.text.gsub('&', 'and') =~ /#{data['business'].gsub('&', 'and')}/i
    resultContent = Nokogiri::HTML(RestClient.get(resultLink["href"]))
    businessFound['status'] = :claimed
    businessFound['listed_name'] = resultLink.text # Return business name given on webpage
    #puts("Listed Name: " + businessFound['listed_name'])
    businessFound['listed_url'] = resultLink.attr("href")
    #puts("Listed Url: " + businessFound['listed_url'])
    businessFound['listed_address'] = page.css("span#ctl00_ContentPlaceHolder1_dlResults_ctl00_lblAddress").text
    #puts("Listed Address: " + businessFound['listed_address'])
    businessFound['listed_phone'] = resultContent.xpath('//*[@id="content-left"]/text()[6]').to_s.gsub("phone:","").gsub(" ","")
    #puts("Listed Phone: " + businessFound['listed_phone'])
  end
end

[true, businessFound]