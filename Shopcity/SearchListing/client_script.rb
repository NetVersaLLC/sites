businessFound = {}

url = "http://www.shopcity.com/map/mapnav_locations.cfm?region=1001&state=#{CGI.escape(data['state'])}"

a = Mechanize.new
cities = a.get(url).parser
citylink = cities.css("a.navlinks").select { |a| a.text =~ /#{data['city']}/ }
citylink = citylink[0]['href']
searchLink = citylink + "/search/inner_results.cfm?where=#{CGI.escape(data['citystate'])}&action=search&type=businesses&q=#{CGI.escape(data['business'])}&categories_search=1&business_posts_search=1&business_search=1&marketplace_search=1%20HTTP/1.1"
page = a.get(searchLink).parser

thelist = page.css("div.business_title_area a")

businessFound['status'] = :unlisted
thelist.each do |item|
next if item.text =~ /report mistake/
  next if not item.text =~ /#{data['business']}/i  
  thelink = item['href']
  subpage = a.get(thelink).parser
  
  bisinfo = subpage.xpath('//td[@class="content maintext"][2]//div[@class="inner_box"]').text.strip.split("\n")

  businessFound['listed_address'] = bisinfo[0].gsub!("\r", "")
  businessFound['listed_phone'] = bisinfo[1].gsub!(" | phone", "")

  if subpage.xpath('//*[@id="toppod"]/tbody/tr[2]/td[2]/div/div[1]/div/a/b').length == 0
    businessFound['status'] = :claimed
    break
  else
    businessFound['status'] = :listed
    break
  end
end

[true, businessFound]