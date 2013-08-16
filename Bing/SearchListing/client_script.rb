#require 'rest-client'
#require 'nokogiri'
#require 'awesome_print'

phone = data['phone']
name = data['business']
zip = data['zip']

html = RestClient.get "https://www.bingplaces.com/DashBoard"

nok = Nokogiri::HTML( html )
my_token = nil
trace_id = nil
nok.xpath("//input[@name='__RequestVerificationToken']").each do |token|
  my_token = token.attr('value')

end

nok.xpath("//input[@name='TraceId']").each do |token|
  trace_id = token.attr('value')
end

headers = html.headers
cookie = headers[:set_cookie]

sessId = cookie[0].split(";")[0]
reqTok = cookie[3].split(";")[0]
culture = cookie[2].split(";")[0]
theCookie = culture + "; " + reqTok + "; " + sessId


url = 'https://www.bingplaces.com/DashBoard/PerformSearch'

params = {'__RequestVerificationToken' => my_token,
'TraceId' => trace_id,
'Market' => 'en-US',
'PhoneNumber' => phone,
'BusinessName' => '',
'City' => '',
'SearchCond' => 'SearchByCountryAndPhoneNumber',
'ApplicationContextId' => 'undefined'}

rheaders = {
  'Accept' => "*/*",
  "Accept-Encoding" => "gzip,deflate,sdch",
  "Accept-Language" => "en-US,en;q=0.8",
  "Connection" => "keep-alive",
  "Content-Length" => "337",
  "Content-Type" => "application/x-www-form-urlencoded; charset=UTF-8",
  "Cookie" => theCookie,
  "Host" => "www.bingplaces.com",
  "Origin" => "https://www.bingplaces.com",
  "Referer" => "https://www.bingplaces.com/DashBoard",
  "User-Agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.72 Safari/537.36",
  "X-Requested-With" => "XMLHttpRequest"
}
 

#ap url
#ap params
#ap rheaders


#puts params

resp = RestClient.post url,params,rheaders

#puts resp

resNok = Nokogiri::HTML(resp)

businessListed = {}
businessListed['status'] = :unlisted


if result = resNok.xpath("//a[@title='#{name}']")

  #puts result
 
  businessListed['listed_url'] = result.attr("href").text
  businessListed['listed_phone'] = phone
  businessListed['listed_name'] = result.text
  
  listPage = RestClient.get result.attr("href").text
  listNok = Nokogiri::HTML(listPage)    

  businessListed['listed_address'] = listNok.css("span.business_address")[0].text
  

  if resNok.css('a[@value="Select"]')
    businessListed['status'] = :listed
  else
    businessListed['status'] = :claimed
  end


  #puts resNok.xpath('//*[@id="0"]/tbody/tr/td[2]/p[1]').text  
  #puts resNok.xpath("a[@title='#{name}']following-sibling")

end

#puts resp
#puts businessListed
[true, businessListed]
