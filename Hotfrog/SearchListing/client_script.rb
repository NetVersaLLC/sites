require 'nokogiri'
require 'open-uri'
#Watir/Nokogiri Hybrid
@browser = Watir::Browser.new
url = "http://www.hotfrog.com"
@browser.goto(url)

@browser.text_field(:id, 'ctl00_contentSection_Search1_txtWhat').set data['business']
@browser.text_field(:id, 'ctl00_contentSection_Search1_txtWhere').set data['location']
@browser.span(:text, 'Search').click
sleep(8) #ensure results load
frame = @browser.frame(:name, 'googleSearchFrame')
firstlink = frame.links.first.attribute_value('href')
page = Nokogiri::HTML(open(firstlink))
puts("Grabbed link: " + firstlink)
businessFound['listed_url'] = firstlink
if page.at_css("div.featured-tile-content")
	fresult = page.xpath('//*[@id="flcn1"]').text
	if fresult == data[ 'business' ]
		fsublink = page.xpath('//*[@id="flcn1"]')[0]["href"]
    factual = Nokogiri::HTML(open(fsublink))
    	if factual.at_xpath('//*[@id="content"]/div[2]/div[3]/p').text.length == 0 then
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
elsif page.at_css("div.tile-content") then
	result = page.at_xpath('//*[@id="bp1"]').text
	if result == data[ 'business' ]
		sublink = page.xpath('//*[@id="bp1"]')[0]["href"]
    	actual = Nokogiri::HTML(open(sublink))
		if actual.at_xpath('//*[@id="content"]/div[2]/div[3]/p').text.length == 0 then
			puts("Business is claimed")
   			businessFound['status'] = :claimed
  		else
  			puts("Business is listed")
   			businessFound['status'] = :listed
  		end
  		puts("Listed Address: " + actual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[1]').text)
  		businessFound['listed_address'] = actual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[1]').text
  		puts("Listed Phone: " + actual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[2]').text)
  		businessFound['listed_phone'] = actual.at_xpath('//*[@id="content"]/div[2]/div[4]/text()[2]').text
  	else
    puts("Business is unlisted")
    businessFound['status'] = :unlisted
 	end
else
	if page.at_css('h1.company-heading').text == data['business'] then
		if page.at_xpath('//*[@id="content"]/div[2]/div[3]/p').text.length == 0
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
		puts("First link business name incorrect match, assuming unlisted")
		businessFound['status'] = :unlisted
	end
end

puts("Success!")
[true, businessFound]