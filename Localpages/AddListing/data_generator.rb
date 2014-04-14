data = {}
catty				= Localpages.where(:business_id => business.id).first
data['category1']   = LocalpagesCategory.find(catty.category_id).parent.name.chomp
data['category2']   = LocalpagesCategory.find(catty.category_id).name.chomp
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
