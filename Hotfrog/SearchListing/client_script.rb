require 'nokogiri'
require 'open-uri'
businessFound = {}
results = Nokogiri::HTML(open("http://www.google.com/custom?q=#{data['businessfixed']}+#{data['city']}++#{data['state']}&client=rbi-cse&cof=FORID:10%3BAH:left%3BCX:HotFrog%2520US%2520Custom%2520Search%2520Engine%3BL:http://www.google.com/intl/en/images/logos/custom_search_logo_sm.gif%3BLH:30%3BLP:1%3BVLC:%23551a8b%3BDIV:%23cccccc%3B&cx=015071188996636028084:ihs3t9hzgq8&channel=hotfrog"))
resultshref = results.css(' a').map { |link| link['href']} #Compile results
firstlink = resultshref[1] #Grab first result
page = Nokogiri::HTML(open(firstlink)) #Open first result
puts("Grabbed link: " + firstlink)
if page.at_css('h1.company-heading') then #Check type of result returned
  puts("Result Type 1")
  if page.at_css('h1.company-heading').text == data['business'] #Is it the correct business?
    businessFound['listed_url'] = firstlink
    if page.at_xpath('//*[@id="content"]/div[2]/div[3]/p').text.length == 0 #Check for claim text
      puts("Business is claimed")
      businessFound['status'] = :claimed
    else
      puts("Businesss is listed")
      businessFound['status'] = :listed
    end
    puts("Listed Address: " + page.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[1]').text)
    businessFound['listed_address'] = page.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[1]').text
    puts("Listed Phone: " + page.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[2]').text)
    businessFound['listed_phone'] = page.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[2]').text
  else
    puts("Incorrect Business Name, assuming unlisted")
    businessFound['status'] = :unlisted
  end
elsif page.xpath("//a[text()='#{data['businesses']}']") # Does the business exist on the page?
  puts("Result Type 2")
  fsublink = page.at_xpath("//a[text()='#{data['business']}']/@href").to_s #Grab the href
  puts("Listed Url: " + fsublink)
  businessFound['listed_url'] = fsublink
  factual = Nokogiri::HTML(open(fsublink)) #Open grabbed href in Nokogiri
  if factual.at_xpath('//*[@id="content"]/div[2]/div[3]/p').text.length == 0 then #Check for Claim
    puts("Business is claimed")
    businessFound['status'] = :claimed
  else
    puts("Business is listed")
    businessFound['status'] = :listed
  end
  puts("Listed Address: " + factual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[1]').text)
  businessFound['listed_address'] = factual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[1]').text
  puts("Listed Phone: " + factual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[2]').text)
  businessFound['listed_phone'] = factual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[2]').text
else
  puts("Busines is unlisted")
  businessFound['status'] = :unlisted
end

puts("Success!")
[true, businessFound]