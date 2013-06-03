

data[ 'businessfixed' ]          = data['business'].gsub(" ", "%20")


url = "http://www.cornerstonesworld.com/en/directory/country/USA/keyword/#{data['businessfixed']}/zip/#{data['zip']}/new"
puts(url)

page = Nokogiri::HTML(RestClient.get(url))

firstItem = page.css("span.titlesmalldblue")


#Unneeded Watir rescue script, incomplete
#rescue
#	@browser.goto('www.cornerstonesworld.com')
#	puts("Arrived at website")
#	@browser.text_field(:name, 'kw').set data['business']
#	puts("Keyword Complete")
#	@browser.select_list(:id, 'cn').select data['country']
#	puts("Country Selected")
#	@browser.text_field(:id, 'zip').set data['zip']
#	puts("Zip Complete")
#	@browser.button(:name, 'sbm').click
#	puts("Submitted")

#end
#begin
# if @browser.table(:class, 'dirlist').include? data['business'] then
#	puts("Business Found")
#	businessFound = [:listed, :unclaimed]
# else
# 	puts("Business unlisted")
#   businessFound = [:unlisted]
#end

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

[true,businessFound]