#data['region'] = 					business.city + ', ' + business.state
#data['gender'] = 					business.contact_gender
#data['dob'] =						business.contact_birthday
data = {}

catty                    		   = Yellowtalk.where(:business_id => business.id).first
data[ 'phone' ] = 					business.local_phone
#data[ 'username' ] = 				'Forth_Record_recreate_coca_cola'
data[ 'username' ] = 				business.bings.first.email.split("@")[0] + 9.to_s
#data[ 'username' ] = 				'A123456789'
data[ 'email' ] = 					business.yellowtalks.first.email 
#data[ 'email' ] = 					"Cowan_age_cia@inbox.com"
data['category'] = 					catty.yellowtalk_category.name
#data['category'] = 					'Television Repair'
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
#data[ 'password' ] = 				'A123456789'
data[ 'reason_for_info_update'] = 	''
data