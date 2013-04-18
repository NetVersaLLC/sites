url = "http://www.matchpoint.com/dest?q=#{data['businessfixed']}&g=#{data['city']}%2C+#{data['state_short']}&id=1198&jump=dummy+flow+page&from=searchForm"
page = Nokogiri::HTML(RestClient.get(url)) 

thelist = page.css('div.mp-result.isFree')

if not thelist.length == 0
  
  subitem = thelist[0]
  if subitem.css("a.mp-claim-biz-text").length == 0
    businessFound = [:listed, :claimed]
  else
    businessFound = [:listed, :unclaimed]
  end
  
else
  businessFound = [:unlisted]
end

[true, businessFound]