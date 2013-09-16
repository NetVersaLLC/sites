data = {}
catty 					= Byzlyst.where(:business_id => business.id).first
data['category']		= catty.byzlyst_category.name.chomp
data['username']		= business.byzlysts.first.username
data['password']		= business.byzlysts.first.password
data['business']		= business.business_name
data['tagline']			= business.tag_line
data['short_desc']		= business.business_description
data['full_desc']		= business.business_description
data['keywords']		= business.keywords
data['website']			= business.company_website
data['address']			= business.address
data['city']			= business.city
data['state']			= business.state
data['zip']				= business.zip
data