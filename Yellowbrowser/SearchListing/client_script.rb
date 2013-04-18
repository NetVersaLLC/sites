#Method for search listing
	
def search_business(data)
  @browser.text_field( :name => 'name' ).set data[ 'business' ]
  @browser.text_field( :name => 'city' ).set data[ 'city' ]
  @browser.select_list(:name => 'state').option(:value => data['state']).select
  @browser.button(:value =>'Search').click
  # Check for business
  $businessFound = [:unlisted]
  page = Nokogiri::HTML(@browser.html)
  page.css('span').each do |span|
    business = span.text.strip
    if business == data['business']
      @browser.link(:text=>/#{data[ 'business' ]}/).click
      if @browser.link(:text => 'Claim Business').exist?
        $businessFound = [:listed,:unclaimed]
      else
        $businessFound = [:listed,:claimed]
      end
    end
  end
  return [true, $businessFound]
end

#Main steps
@url = 'http://www.yellowbrowser.com/'
@browser.goto(@url)
search_business(data)
