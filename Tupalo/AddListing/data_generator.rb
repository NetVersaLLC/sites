data = {}
catty = Tupalo.where(:business_id => business.id).first
data['category1']	= catty.tupalo_category.parent.name
data['category2']	= catty.tupalo_category.name
data[ 'email' ]		= business.tupalos.first.username
data[ 'password' ] 	= business.tupalos.first.password
data['business']	= business.business_name
data['address']		= business.address+ " " + business.address2
data['citystatecountry']	= business.city + ", " + business.state + ", " + "United States"
data['citystate']	= business.city + ", " + business.state
data['website']		= business.company_website
data['phone']		= business.local_phone
data
