url = "http://yellowtalk.com/findbusinesses.php/#{data['businessfixed']}/zip/#{data['zip']}/new"

page = Nokogiri::HTML(RestClient.get(url)) 
firstItem = page.css("span.titlesmalldblue")
businessFound = {}
if firstItem.length == 0
  businessFound['status'] = :unlisted
else
   if firstItem.text == data['business']
      businessFound['status'] = :listed
      businessFound['listed_address'] 	= firstItem.parent.text
      businessFound['listed_url']		= url
   else
	  businessFound['status'] = :unlisted
   end  
end