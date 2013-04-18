def claim_business( applicableLinks, data )

	puts "Selcting found business from search results."
	listIndx = applicableLinks.collect { |listing| listing[0] == data['business'] }.find_index(true)
	@browser.link(:href, applicableLinks[listIndx][1][0]).click
	puts 'Claiming as business owner'

	until !!@browser.execute_script("return document.location.toString();")[/.*about/]
		sleep 3 # The url has to be the business page... wait for it... wait for it.
	end

	@browser.div(:class => "a-f-e c-b c-b-T BNa FPb Ppb").click # Manage this page
	
	#Wait for login page
	@browser.wait
	
	if @browser.title.include?('Welcome to Google Places')
		@browser.text_field(:id, "Passwd").set data['pass']
		@browser.button(:value, "Sign in").click
	end

	@browser.radio(:value => "edit").click # Edit
	@browser.button(:name, "continue").click 
	
	# TODO Confirm following page.
end

login( data )
search_for_business( data )
parse_results( data )
claim_business(parse_results( data ), data)