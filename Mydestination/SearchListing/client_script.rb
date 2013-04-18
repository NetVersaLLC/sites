# Search for the business

def search_business(data)
  @browser.link(:text=> "#{data[ 'continent' ] }").click
  @browser.div(:class => 'boxholder onescroll').link(:text=> "#{data[ 'country' ] }").click
  @browser.div(:class => 'boxholder onescroll').link(:text=> "#{data[ 'city' ] }").when_present.click
  @browser.text_field(:name => 'q').set data['business']
  @browser.button(:value => 'Go').click
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

@browser.goto('http://www.mydestination.com')
search_business(data)
