data = {}
catty				= LocalpagesCategory.find business.localpages.first.category_id
data['category1']   = catty.parent.name.gsub("\n", "")
data['category2']   = catty.name.gsub("\n", "")
data['username']		= business.localpages.first.username
data['password']		= business.localpages.first.password
data['business']		= business.business_name
data['address']			= business.address
data['address2']		= business.address2
data['city']			  = business.city
data['state']			  = business.state_name
data['zip']			    = business.zip
data['phone']			  = business.local_phone
data['website']			= business.company_website
data
