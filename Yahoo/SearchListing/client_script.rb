businessFound = {}

citystate = data['city'] + ", " + data['state_short']
html = RestClient.get "http://local.search.yahoo.com/search", { :params => { :p => data['business'], :addr => citystate, :fr2 => 'sb-top', :type_param => '' } }
nok = Nokogiri::HTML(html)

businessFound = {
  'status' => :unlisted
}
nok.xpath("//div[@class='res']/div[@class='content']").each do |content|
  content.xpath("./h3").each do |h3|
    if h3.inner_text.strip =~ /#{data['business'].strip}/i
      h3.xpath("./a").each do |a|
        url = a.attr('href')
        if url =~ /(local.yahoo.com.*)/
          businessFound['listed_url'] = "http://#{$1}"
          puts("Listed Url: " + businessFound['listed_url'])
        end
      end
      businessFound['status'] = :listed
      puts("Listed")
      content.xpath("./span[@class='merchant-ver']").each do |div|
        businessFound['status'] = :claimed
        puts("Claimed")
      end
      
      content.xpath("./div[@class='phone']").each do |phone|
        businessFound['listed_phone'] = phone.inner_text.strip
        puts("Listed Phone: " + businessFound['listed_phone'])
      end
      content.xpath("./div[@class='address']").each do |address|
        address.xpath("./div").each do |div|
          div.remove
        end
        businessFound['listed_address'] = address.inner_text.strip
        puts("Listed Address: " + businessFound['listed_address'])
      end
    end
  end
  break
end

[true, businessFound]
