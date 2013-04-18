#search for business
def search_business(data)
  @browser.text_field( :id => 'Name' ).set data[ 'business' ]
  @browser.text_field( :id => 'Ort' ).set data[ 'city' ]
  @browser.button(:id =>'ctl00_submit').click

  # Check for business
  $businessFound = [:unlisted]
  page = Nokogiri::HTML(@browser.html)

  page.css('a').each do |link|
    if link.text == data['business']
	@browser.link(:text=> data['business']).click
	if @browser.window(:title, /#{data['business']}/).use do 
	  if @browser.link(:text => 'Edit this entry').exist?
	    $businessFound = [:listed,:claimed]
	  else
	    $businessFound = [:listed,:unclaimed]
          end
        end
    end
  end
  end
  return [true, $businessFound]
end

# Main steps
@browser.goto( "http://www.cylex-usa.com/" )
search_business(data)
