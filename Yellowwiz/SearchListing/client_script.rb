
require 'nokogiri'
burl="http://www.yellowwiz.com/"
html="#{burl}Business_Listings.php?name=#{name}&city=#{city}&state=#{state}&current=1&Submit=Search"

nok = Nokogiri.HTML(html)
puts(nok)
business_rows = nok.css('table.vc_result > tbody > tr')
details = business_rows.map do |tr|
  # Inside the first <td> of the row, find a <td> with a.cAddName in it
  business = tr.at_xpath('td[1]//td[//a[@class="cAddName"]]')
  name     = business.at_css('a.cAddName').text.strip
  address  = business.at_css('.cAddText').text.strip

  # Inside the second <td> of the row, find the first <font> tag
  phone    = tr.at_xpath('td[2]//font').text.strip

  # Return a hash of values for this row, using the capitalization requested
  { Name:name, Address:address, Phone:phone }
end
p details