html = RestClient.get "http://local.search.yahoo.com/search", { :params => { :p => @data['business'], :addr => @data['citystate'], :fr2 => 'sb-top', :type_param => '' } }
nok = Nokogiri::HTML(html)
businessFound = [:unlisted]
nok.xpath("//div[@class='res']/div[@class='content']").each do |content|
  content.xpath("./h3").each do |h3|
    if @data['business'].strip == h3.inner_text.strip
      businessFound = [:listed, :unclaimed]
      content.xpath("./span[@class='merchant-ver']").each do |div|
        businessFound = [:listed, :claimed]
      end
      meta = {}
      meta['name'] = h3.inner_text.strip
      content.xpath("./span[@class='phone']").each do |phone|
        meta['phone'] = phone.inner_text
      end
      content.xpath("./div[@class='address']").each do |address|
        address.xpath("./div").each do |div|
          div.remove
        end
        meta['address'] = address.inner_text
      end
      businessFound.push meta
    end
  end
end

[true, businessFound]
