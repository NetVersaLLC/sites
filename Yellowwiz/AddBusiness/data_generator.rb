data = {}

data[ 'phone' ] = 					business.local_phone
data[ 'keywords'] = 				business.keywords
#data[ 'username' ] = 				'Forth_Record_recreate_coca_cola'
data[ 'username' ] = 				business.bings.first.email.split("@")[0] + 9.to_s
data[ 'email' ] = 					business.bings.first.email 
#data[ 'email' ] = 					"Cowan_age_cia@inbox.com"
data[ 'business' ] = 				business.business_name
data[ 'address' ] = 				business.address + ' ' + business.address2
data[ 'city' ] = 					business.city
data[ 'state' ] = 					business.state 
data[ 'zip' ] = 					business.zip
data[ 'business_description'] = 	business.business_description
data[ 'website'] = 					business.company_website
data[ 'role' ] = 					'owner'
data[ 'name_title' ] = 				business.contact_prefix
data[ 'first_name' ] = 				business.contact_first_name
data[ 'last_name' ] = 				business.contact_last_name
data[ 'password' ] = 				Yahoo.make_password
#data[ 'password' ] = 				'coinage'
data[ 'reason_for_info_update'] = 	''
data