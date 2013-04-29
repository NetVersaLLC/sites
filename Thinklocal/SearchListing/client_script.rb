# Method for search existing business
def search(data)
  @browser.text_field(:id => /txtKeyword/).set data['business']
  @browser.text_field(:id => /txtWhere/).set data['city']
  @browser.button(:id => /b_search/).click
 
  # Check for business
  $businessFound = [:unlisted]
  page = Nokogiri::HTML(@browser.html)
  puts page.css
  page.css('a').each do |link|
    puts link
    business = link.text.strip
    if business == data['business']
      @browser.link(:text=>/#{data[ 'business' ]}/).click
      if @browser.link(:text => 'Claim Business').exist?
        $businessFound = [:listed,:unclaimed]
      else
        $businessFound = [:listed,:claimed]
      end
    end
  return [true, $businessFound]
end
end

#Main steps
@url = 'http://www.thinklocal.com/Business-Signup.aspx'

@browser.goto(@url)
search(data)
