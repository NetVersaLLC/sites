#Written by Kazyyk, 7/25/13
#Made better by bluedot, on the evening of July 27th, the year of our Lord, 2013

data['businessfixed'] = data['business'].gsub(" ","+").gsub(",","")
url = "http://www.gomylocal.com/listings/" + data['zip'] + "-" + data['businessfixed']
page = Nokogiri::HTML(RestClient.get url)
businessFound = {}
if page.at_css("a.links_12pt_bold").text.include? data['business'] then
  if not page.at_xpath("//a[text()='Claim Business']").nil? then
    puts("Business is not claimed")
    businessFound['status'] = :claimed
    # No way to tell if claimed or unclaimed without logging in. All listings give the option to attempt to claim
  else
    puts("Business is claimed")
    businessFound['status'] = :claimed
  end
  businessFound['listed_url'] = page.at_css("a.links_12pt_bold")["href"]
  puts("Listed Url: " + businessFound['listed_url'])
  page = Nokogiri::HTML(RestClient.get page.at_css("a.links_12pt_bold")["href"] )
  businessFound['listed_address'] = page.css("span.span_new")[0].text.gsub(/(&nbsp;)+/, "") + page.css("span.span_new")[1].text.gsub(/(&nbsp;)+/, "")
  puts("Listed Address: " + businessFound['listed_address'])
  businessFound['listed_phone'] = page.css("span.phonenumber").text.gsub(/(&nbsp;)+/, "")
  puts("Listed Phone: " + businessFound['listed_phone'])
else
  puts("Business is unlisted")
  businessFound['status'] =  :unlisted
end

[true, businessFound]