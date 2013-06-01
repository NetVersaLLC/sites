agent = Proxy.mechanize
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
agent.user_agent_alias = 'Mac Safari'
agent.get('https://biz.yelp.com/signup')

businessFound = {}
businessFound['status'] = :unlisted

agent.page.forms[0]['query'] = data['business']
agent.page.forms[0]['location'] = data['zip']
page = agent.page.forms[0].submit


obj = JSON.parse(page.body)
nok = Nokogiri::HTML(obj.to_s.gsub('\\"',""))
nok.css("li.business-result").each do |item|
	if item.css("li.name-col/h3/text()").to_s =~ /#{data['business']}/
		if item.css("span[text()='Unlock']")
			businessFound['status'] = :listed
		else
			businessFound['status'] = :claimed
		end
    item.xpath(".//input[@name='business_url']").each do |input|
      businessFound['listed_url'] = input.attr('value')
    end

		businessFound['listed_address'] = item.css("address").inner_text.gsub("\\n"," ").gsub("\\t"," ").strip
		businessFound['listed_phone'] = item.css("span.phone").inner_text.gsub("\\n"," ").gsub("\\t"," ").strip
		break
	end
end
[true, businessFound]
