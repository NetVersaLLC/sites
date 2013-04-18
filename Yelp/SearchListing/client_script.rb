agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
agent.user_agent_alias = 'Mac Safari'
agent.get('https://biz.yelp.com/signup')
businessFound = [:unlisted]
meta = {}
agent.page.forms[0]['query'] = data['business']
agent.page.forms[0]['location'] = data['zip']
page = agent.page.forms[0].submit


obj = JSON.parse(page.body)
nok = Nokogiri::HTML(obj.to_s.gsub('\\"',""))
nok.css("li.business-result").each do |item|
	if item.css("li.name-col/h3/text()").to_s =~ /#{data['business']}/
		if item.css("span[text()='Unlock']")
			businessFound = [:listed,:unclaimed]
		else
			businessFound = [:listed,:claimed]
		end

		meta['name'] = item.css("li.name-col/h3").inner_text
		meta['address'] = item.css("address").inner_text.gsub("\\n","").gsub("\\t","")
		meta['phone'] = item.css("span.phone").inner_text.gsub("\\n","").gsub("\\t","")
		businessFound.push meta
		break
	end
end
[true, businessFound]
