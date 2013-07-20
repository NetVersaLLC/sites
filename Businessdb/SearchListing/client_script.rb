#Replace '&' with 'and'
def replace_and(business)
  return business.gsub("&","and")
end

url = "http://search.businessdb.com/?q=#{CGI.escape(data['business'])}"
businessFound = {}
page = Nokogiri::HTML(RestClient.get(url))

if page.text.include? "Your search \"#{data['business']}\" did not match with any companies"
  businessFound['status'] = :unlisted
else
  page.xpath("//div[@id='business-results']/a").each do |item|
    if replace_and(item.css('span.name').text) =~ /#{replace_and(data['business'])}/i
      businessFound['listed_name'] = item.css('span.name').text
      businessFound['listed_address'] = item.css('span.address').text
      businessFound['listed_url'] = item.attr('href')

      nok = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
      if nok.css("a#claim").length > 0
        businessFound['status'] = :listed
      else
        businessFound['status'] = :claimed
      end
      break
    end
  end
end

[true, businessFound]

if search_business(data)
  puts "Business Already Exist"
  businessFound = [:listed,:unclaimed]
else
  businessFound = [:unlisted]
end

def search_business(data)
  matching_result = false
  @browser.text_field(:id=> 'home-search-txt').clear
  @browser.text_field(:id=> 'home-search-txt').set data[ 'location' ]
  @browser.text_field(:id=> 'home-search-txt').send_keys(:return)
  list = @browser.div(:class=>'nine columns', :index=>1).ul(:class=>'social-list')
   if list.exist?
     list.lis.each do |li|
       if li.text.include?(data[ 'business' ])
         matching_result = true    
         break
       end
     end
  end
  return matching_result 
end
