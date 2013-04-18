businessFound = [:unlisted]
meta = {}

phone = data['phone'].split("-")
finalphone = "("+phone[0]+")"+"+"+phone[1]+"-"+phone[2]
url = "http://www.magicyellow.com/add-your-business.cfm?step=2&phone=#{finalphone}"
puts(url)
html = RestClient.get url
nok = Nokogiri::HTML(html)
nok.xpath("//tr[@title='Claim this Business']").each do |listing|
	
	if listing.css("a").first.text =~ /#{data['business']}/i
		if nok.at_xpath("//a[@title='Claim this Business']")
			businessFound = [:listed, :unclaimed]
		else
			businessFound = [:listed, :claimed]
		end

		meta['phone'] = data['phone']
		stupidfuckingtable = listing.css("a").first.parent.parent.parent
		meta['address'] = stupidfuckingtable.children[2].text
		meta['name']	= listing.css("a").first.text
		businessFound.push(meta)
		break
	end	
end


[true,businessFound]