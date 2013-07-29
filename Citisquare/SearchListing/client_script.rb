resp = RestClient.post 'http://my.citysquares.com/add_search', {
  'b_standardname'  => data['business'],
  'b_zip'           => data['zip']
}
#puts resp.headers

nok = Nokogiri::HTML resp


businessListed = {}
businessListed['status'] = :unlisted


nok.css('div#bizData').each do |listing|

  listing.xpath("//a[1]").each do |link|
    
    if link.text =~ /#{data['business']}/i
      businessListed['status'] = :claimed
      businessListed['listed_url'] = link.attr("href")

      resp2 = RestClient.get(businessListed['listed_url'])
      nok2 = Nokogiri::HTML(resp2)

      businessListed['listed_phone'] = nok2.css("div#bizPhone").text
      businessListed['listed_address'] = nok2.css("span.street-address").text + ", " + nok2.css("span.locality").text + ", " + nok2.css("span.region").text + ", " + nok2.css("span.postal-code").text
      businessListed['listed_name'] = data['business']

      break
    end

  end
  #businessListed['listed_url'] = listing.xpath("//a").attr("href")

end

[true, businessListed]
