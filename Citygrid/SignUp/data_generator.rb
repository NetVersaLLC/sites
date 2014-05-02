data = {}
data[ 'first_name' ]	= business.contact_first_name
data[ 'last_name' ] 	= business.contact_last_name
data[ 'area-code' ] 	= business.local_phone[0..2]
data[ 'prefix' ] 	= business.local_phone[3..5]
data[ 'number' ] 	= business.local_phone[6..9]
data[ 'email' ]		= business.bings.first.email
data[ 'password' ]	= Yahoo.make_password
data[ 'business_name' ] = business.business_name
data[ 'zip' ] 		= business.zip
data
