# Search for the business

def search_business(data)
  @browser.text_field( :id => 'search_str' ).set data[ 'business' ]
  @browser.link(:title =>'Click to search').click
  @browser.select_list(:name => 'state_sel').option(:value=> "#{data[ 'state' ]}").select
  @browser.select_list(:name => 'city_sel').option(:value=> "#{data[ 'city' ]}").select
  # Check for business
  $businessFound = [:unlisted]
  page = Nokogiri::HTML(@browser.html)

  page.css('a').each do |link|
    if link.text.include?(data['business'])
        $businessFound = [:listed,:claimed]
    end
  end
  return [true, $businessFound]
end

# Main steps
@browser.goto( "http://freebusinessdirectory.com" )
search_business(data)
