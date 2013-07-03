data = {}

catty                    		   = Yellowtalk.where(:business_id => business.id).first
data[ 'phone' ] = 					business.local_phone
#data[ 'username' ] = 				'A123456789'
data[ 'username' ] = 				business.bings.first.email.split("@")[0] + 9.to_s
data['region'] = 					business.city + ', ' + business.state
data['gender'] = 					business.contact_gender
data['dob'] =						business.contact_birthday
data[ 'password' ] = 				business.yellowtalks.first.password
data[ 'reason_for_info_update'] = 	''
data