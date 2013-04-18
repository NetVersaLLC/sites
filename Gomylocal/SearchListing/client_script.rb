#Search business
def search_business(data)
  @browser.text_field( :id => 'search_bar_category' ).set data[ 'business' ]
  @browser.text_field( :id => 'search_bar_zip' ).set data[ 'zip' ]
  @browser.button(:name =>'imageField').click
  # Check for business
  $businessFound = [:unlisted]
  page = Nokogiri::HTML(@browser.html)
  page.css('a').each do |link|
    business = link.text.strip
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

#main steps
@url = 'http://www.gomylocal.com/'
@browser.goto(@url)
search_business(data)
