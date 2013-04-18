# Search for the business

def search_business(data)
  @browser.text_field( :id => 'what' ).set data[ 'business' ]
  @browser.text_field( :id => 'where' ).set data[ 'zip' ]
  @browser.button( :id => 'find_btn' ).click
  $businessFound = [:unlisted]
  page = Nokogiri::HTML(@browser.html)
  page.css('a').each do |link|
    if link.text.include?(data['business'])
      "Business is already listed"
      @browser.div(:class=> 'box-content').link(:text=>data[ 'business' ]).click
      @browser.link( :text => 'Own This Business' ).click
      if @browser.text.include?("This business has already been claimed")
        $businessFound = [:listed,:claimed]
      else
        $businessFound = [:listed,:unclaimed]
      end
    end
  end
  return [true, $businessFound]
end

# Main steps
@browser.goto( "http://www.citygrid.com" )
search_business(data)
