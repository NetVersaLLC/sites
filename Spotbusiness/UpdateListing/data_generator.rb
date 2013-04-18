data = {}
catty = Spotbusiness.where(:business_id => business.id).first
data['username']	= business.spotbusinesses.first.email
data['password']	= business.spotbusinesses.first.password

data[ 'email' ]		= business.bings.first.email 
data[ 'first_name' ] 	= business.contact_first_name
data[ 'last_name' ] 	= business.contact_last_name
data[ 'full_name' ] 	= data[ 'first_name' ] +' '+ data[ 'last_name' ] 
data[ 'address' ] 	= business.address + ' ' + business.address2
data[ 'city' ] 		= business.city
data[ 'state' ] 	= business.state_name
data[ 'zip' ] 		= business.zip
data[ 'business' ] 	= business.business_name
data[ 'profile_type'] 	= 'profile_right_wht'
data[ 'business_category' ] = catty.spotbusiness_category.name
data