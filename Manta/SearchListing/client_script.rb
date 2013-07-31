  data['business_location'] =  data[ 'business' ] +', '+data[ 'city' ] +' '+ data[ 'state' ] 

  #replace '&' with 'and'
  def replace_and(business)
    return business.gsub("&","and")
  end

  # Main steps
  @browser.goto( "http://www.manta.com" )
  @browser.text_field( :id => 'search-home-lo' ).set data['business_location']
  @browser.form(:id=> 'search-home-lo-submit').button.click
  @browser.wait_until {@browser.div(:class=> 'results-area').exist?}
  
   businessFound = {}
   businessFound['status'] = :unlisted
   page = Nokogiri::HTML(@browser.html)
   page.css('li > div.result-box').each do |item|

  if replace_and(item.at_css("h2").text) =~ /#{replace_and(data['business'])}/
      businessFound['listed_name'] = item.at_css("h2").text.gsub(/\t+|\r\n+/,'').strip # Return business name given on webpage
      businessFound['listed_url'] = item.at_css("a").attr('href')
      businessFound['listed_address'] = item.xpath("//div[@itemprop='address']")[0].text.gsub(/\t+|\r\n+/,'').strip
      subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
      if subpage.css('div.claimable_link').text.include?('Claim This Profile')
      businessFound['status'] = :listed
      else
      businessFound['status'] = :claimed
      end
      break
  end
  end
  [true, businessFound]
