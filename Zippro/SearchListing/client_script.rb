data[ 'businessfixed' ]          = data['business'].gsub(" ", "+").gsub("-","+")

businessFound = {}
url = "http://#{data['zip']}.zip.pro/#{data['businessfixed']}"
puts(url)
page = Nokogiri::HTML(RestClient.get(url)) 
if page.css("div.organicListing").size > 0
  link = page.css("a.result-title")
  link = link[0]["href"]
  puts(link)
  businessFound['listed_url'] = link
  subpage = Nokogiri::HTML(RestClient.get(link)) 
  claimLink = subpage.css("div.claim_listing")
  if claimLink.size > 0
    puts("Unclaimed")
    businessFound['status'] = :claimed
    #No way to tell if claimed or unclaimed, both show "CLAIM LISTING" link. 
  else
    puts("Claimed")
    businessFound['status'] = :claimed
  end
  phone = subpage.at_css("span.head_phone.iconsprite.inprofile_head").text
  puts(phone)
  businessFound['listed_phone'] = phone
  address = subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[1]').text + subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[2]').text + subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[3]').text + subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[4]').text
  puts(address)
  businessFound['listed_address'] = address
else
  puts("Unlisted")
  businessFound['status'] = :unlisted
end

[true, businessFound]