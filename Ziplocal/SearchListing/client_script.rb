# Search for the business

def search_business(data)
  
  @browser.text_field(:name => 'na').set data['business']
  sleep(2)
  @browser.text_field(:name => 'city').set data['location']
  @browser.radio(:value=> 'N').when_present.set
  @browser.div(:id=> 'button_search_bs').span(:text=>'Search').click
  @browser.wait_until { @browser.div(:id=> 'results').exist? }
  $businessFound = [:unlisted]
  page = Nokogiri::HTML(@browser.html)
  page.css('a').each do |link|
    if link.text.include?(data['business'])
      "Business is already listed"
      $businessFound = [:listed,:claimed]
    end
  end
  return [true, $businessFound]
end

# Main steps

@browser.goto('http://www.ziplocal.com/')
search_business(data)
