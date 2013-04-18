def search_business(data)
  $matching_result = false
  @browser.text_field(:id=> 'home-search-txt').clear
  @browser.text_field(:id=> 'home-search-txt').set data[ 'location' ] 
  @browser.text_field(:id=> 'home-search-txt').send_keys(:return)
  list = @browser.div(:class=>'nine columns', :index=>1).ul(:class=>'social-list')
   if list.exist? 
     list.lis.each do |li|
       if li.text.include?(data[ 'business' ])
         $matching_result = true
         break
       end
     end
  end
  return $matching_result
end
