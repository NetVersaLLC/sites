def search_business(data)
	$matching_result = false
	home_url = 'http://www.discoverourtown.com/'
	@browser.goto(home_url)
	@browser.link(:text=>"#{data[ 'state']}").click
	@browser.link(:text=>"#{data[ 'city']}").click
        @browser.div(:id=>'mainCol').lis.each do |li|
		if li.link(:text=> data['business']).exist?
			$matching_result = true
			puts "Business is already Listed"
		end
	end		
end

#Main Steps

search_business(data)
  
