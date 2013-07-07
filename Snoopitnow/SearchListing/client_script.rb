businessFound = {}

url = "http://www.snoopitnow.com/Search/newest-first.html?condition=companyname&radiobutton=companyname&searchphrase=exact&searchword=#{data['businessfixed']}"

page = Nokogiri::HTML(RestClient.get(url))

thetable = page.css('table.sobi2Listing')

if thetable.length.zero?
  businessFound['status'] = :unlisted
else
  thetable.search('table > tr').each do |row|
    business_name = row.css('h3')
    next if business_name == nil

    if business_name.text =~ /#{data['business']}/
      businessFound['status'] = :listed

      businessFound['listed_phone'] = thetable.xpath("//table//table/tr[3]/td[2]/div[1]").text.strip
      nbsp = Nokogiri::HTML("&nbsp;").text
      businessFound['listed_address'] = thetable.xpath("//table//table/tr[3]/td[2]").text.gsub(businessFound['listed_phone'], "").gsub(nbsp, " ").gsub("United States", "").gsub("\r\n", "").strip
      businessFound['listed_categories'] = thetable.xpath("//table//table/tr[4]/td[2]").text.gsub("\r\n", "").strip
    end
  end
end

[true, businessFound]