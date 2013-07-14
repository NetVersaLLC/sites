require 'nokogiri'
require 'open-uri'
url = "http://www.justclicklocal.com/citydir/#{data[ 'city' ]}-#{data[ 'state' ]}--#{data[ 'businessfixed' ]}.html"
puts(url)
page = Nokogiri::HTML(RestClient.get(url)) 
if page.css("ol.initial-results")
  result = page.xpath('//*[@id="r"]/div[2]/div[1]/ol[1]/li[1]/div[2]/a').text
  if result == data[ 'business' ] 
    puts("Listed")
    businessFound = [:listed]
  else
    puts("Unlisted")
    businessFound = [:unlisted]
end


[true, businessFound]
end