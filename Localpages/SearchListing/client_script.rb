def replace_and(business)
  return business.gsub("&","and")
end

businessfixed = data['business'].gsub(" ", "-")
cityfixed = data['city'].gsub(" ", "-")
url = "http://www.localpages.com/#{data['state_short']}/#{cityfixed}/#{businessfixed}"
puts "halp"

businessFound = {}
begin
  page = Nokogiri::HTML(RestClient.get(url))

  page.css("ul.fluid_results_list > li").each do |item|
    if replace_and(item.at_css("h3").text) =~ /#{replace_and(data['business'])}/
      businessFound['status'] = :listed
      businessFound['listed_name'] = item.at_css("h3").text # Return business name given on webpage
      businessFound['listed_address'] = item.at_css("p").text
      businessFound['listed_phone'] = item.at_css("span.result_phone").text
      businessFound['listed_url'] = item.at_css("a").attr('href')
      if not businessFound['listed_url'].nil?
        subpage = Nokogiri::HTML(RestClient.get(businessFound['listed_url']))
        claimLink = subpage.xpath("/html/body/div[2]/div/div[3]/div[1]/div[3]/div[2]/a")
        if claimLink.length == 0
          businessFound['status'] = :claimed
        else
          businessFound['status'] = :listed
        end
      end
    end
  end
rescue
  businessFound['status'] = :unlisted
end

[true, businessFound]
