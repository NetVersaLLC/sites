data = {}
data[ 'business_name' ]		= business.business_name
data[ 'email' ]				= business.bings.first.email
data[ 'contact_first_name' ]= business.contact_first_name
data[ 'contact_last_name' ]	= business.contact_last_name
data[ 'password' ]			= Yahoo.make_password
data[ 'category1' ]			= business.category1
data[ 'alternate_phone' ]	= business.alternate_phone
data[ 'address' ]			= business.address
data