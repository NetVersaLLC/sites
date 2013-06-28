def format_business(business)
  business_formatted = business.gsub(' ', '-')
  return business_formatted.gsub('&', '')
end

data[ 'businessfixed' ] = format_business(data['business'])

url = "http://www.expressbusinessdirectory.com/businesses/#{data[ 'businessfixed' ] }/"

page = Nokogiri::HTML(RestClient.get(url))
businessFound = {}
businessFound['status'] = :unlisted
page.css("a#ctl00_ContentPlaceHolder1_dlResults_ctl00_hypBusiness").each do |resultLink|
  if resultLink.text.gsub('&', 'and') =~ /#{data['business'].gsub('&', 'and')}/i
    businessFound['status'] = :claimed
    businessFound['listed_url'] = resultLink.attr("href")
    businessFound['listed_address']	= page.css("span#ctl00_ContentPlaceHolder1_dlResults_ctl00_lblAddress").text
  end
end

[true, businessFound]
