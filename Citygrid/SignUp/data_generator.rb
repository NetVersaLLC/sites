data = {}
data[ 'first_name' ]	= business.contact_first_name
data[ 'last_name' ] 	= business.contact_last_name
data[ 'phone_area' ] 	= business.local_phone.split("-")[0]
data[ 'phone_prefix' ] 	= business.local_phone.split("-")[1]
data[ 'phone_suffix' ] 	= business.local_phone.split("-")[2]
data[ 'email' ]		= business.yahoos.first.email
data[ 'password' ]	= business.yahoos.first.password
data[ 'business_name' ] = business.business_name
data[ 'zip' ] 		= business.zip
data
