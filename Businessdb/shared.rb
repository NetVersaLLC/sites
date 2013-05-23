def search_business(data)
  businessFound = [:unlisted]
  @browser.text_field(:id=> 'home-search-txt').clear
  @browser.text_field(:id=> 'home-search-txt').set data[ 'location' ]
  @browser.text_field(:id=> 'home-search-txt').send_keys(:return)
  list = @browser.div(:class=>'nine columns', :index=>1).ul(:class=>'social-list')
   if list.exist?
     list.lis.each do |li|
       if li.text.include?(data[ 'business' ])
         businessFound = [:listed, :unclaimed]    
         break
       end
     end
     else
	 businessFound = [:unlisted]  
  end
  return businessFound
end
