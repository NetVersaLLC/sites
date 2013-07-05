data = {}
 seed = rand( 1000 ).to_s()
catty						= Mojopage.where(:business_id => business.id).first
data[ 'phone_area' ] 		= business.local_phone.split("-")[0]
data[ 'phone_prefix' ] 		= business.local_phone.split("-")[1]
data[ 'phone_suffix' ] 		= business.local_phone.split("-")[2]
data[ 'phone' ] 			= business.local_phone
data[ 'business' ] 			= business.business_name
#seed = rand( 1000 ).to_s()
#data[ 'phone_area' ] = '45' + rand( 10 ).to_s()
#data[ 'phone_prefix' ] = '54' + rand( 10 ).to_s()
#data[ 'phone_suffix' ] = '654' + rand( 10 ).to_s()
#data[ 'phone' ] = data[ 'phone_area' ]+data[ 'phone_prefix' ] +data[ 'phone_suffix' ]
#data[ 'business' ] = 'Test'+seed
data[ 'first_name' ] 		= business.contact_first_name
data[ 'last_name' ] 		= business.contact_last_name
data[ 'email' ] 			= business.bings.first.email #seed  + 
data[ 'streetnumber' ] 		= business.address + ' ' + business.address2
data[ 'city' ] 				= business.city
data[ 'state' ] 			= business.state_name
data[ 'stateabreviation' ] 	= business.state
data[ 'zip' ] 				= business.zip
data[ 'country' ] 			= 'United States'
data[ 'citystate' ] 		= data[ 'city' ] + ', ' + data[ 'stateabreviation' ]
data[ 'url' ] 				= business.company_website
data[ 'tagline' ] 			= (business.business_description + business.business_description + business.business_description+ business.business_description)[0..110]
data[ 'description' ] 		= (business.business_description + business.business_description + business.business_description+ business.business_description)[0..799]
data[ 'password' ] 			= Mojopage.make_password
data[ 'category' ] 			= catty.mojopages_category.name
data[ 'gender' ] 			= business.contact_gender
data

