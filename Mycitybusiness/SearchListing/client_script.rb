require 'rest_client'
require 'nokogiri'

businessFound = {'status' => :unlisted}

page = RestClient.post('http://www.mycitybusiness.net/search.php', {:kword => data[:business], :city => data['city'], :state => data[:state]})
nok = Nokogiri::HTML(page)

nok.xpath("//strong[contains(text(), 'Company / Address')]").each do |top|
	tbody = top.parent.parent.parent
	tbody.children.each do |tr|
		td = tr.xpath("./td[1]")
		if td.attr('colspan') != nil
			title = td.inner_text.strip.gsub(/[^A-Za-z0-9]/, '')
			business = data[:business].strip.gsub(/[^A-Za-z0-9]/, '')
			if title == business
				address = ''
				city    = ''
				phone   = ''
				address_tr = tr.next.xpath("./td[1]/table/tr[1]/td")
				if address_tr and address_tr.length > 0
					address = address_tr.inner_text.strip
				end
				city_tr = tr.next.xpath("./td[1]/table/tr[2]/td")
				if city_tr and city_tr.length > 0
					city = city_tr.inner_text.strip
				end
				businessFound['status']         = 'claimed'
				businessFound['listed_address'] = "#{address} #{city}"
				phone_tr = tr.next.xpath("./td[2]")
				if phone_tr and phone_tr.length > 0
					phone = phone_tr.inner_text.strip
				end
				businessFound['listed_phone'] = phone
			end
		else
			puts "No Title: #{td.inner_html}"
		end
	end
end

[true, businessFound]
