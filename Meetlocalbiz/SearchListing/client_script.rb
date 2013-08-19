#require 'nokogiri'
#require 'rest-client'
#require 'awesome_print'

#data = {}
#data['business'] = "Klein, Emard and Rice"
#data['zip'] 	= "33606"




url = "http://www.meetlocalbiz.com/search/?search_keywords=#{CGI.escape data['business']}&search_zip=#{data['zip']}&mySubmit=+"
#ap url
businessFound = {}
businessFound['status'] = :unlisted

nok = Nokogiri::HTML(RestClient.get url)

#ap nok

nok.css("div.companylisting").each do |listing|
#ap "balp"
	if listing.css("span.biz-name").text =~ /#{data['business']}/i

		#ap listing.css("span.biz-name a").attr("href").text
		businessFound['listed_url'] = "www.meetlocalbiz.com"+ URI.escape(listing.css("span.biz-name a").attr("href").text)
		#ap businessFound['listed_url']
		subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
		ap subpage.css("p.address").text.delete("[google maps]")
		businessFound['listed_address']		= subpage.css("p.address").text.gsub(/\n+|\t+/, "").squeeze(" ").strip.gsub("[google maps]","")
		businessFound['listed_phone']		= subpage.css("p.phone").text.gsub("Ph: ","")
		businessFound['listed_name']		= subpage.css("p.boxtitle").text
		businessFound['status']				= :claimed


		break
	end
end

#ap businessFound
[true, businessFound]