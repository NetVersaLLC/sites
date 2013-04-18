def discern_parse_business_exist?( applicableLinks, data )
	return applicableLinks.collect { |listing| listing[0] == data['business'] }.member?(true)
end

login( data )
search_for_business( data )
matching_result = discern_parse_business_exist?( parse_results( data ), data )

if matching_result == true
  self.start("Google/ClaimListing")
else
  self.start("Google/CreateListing")
end
