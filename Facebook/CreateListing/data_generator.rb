data = {}
data[ 'business_description' ] = business.business_description
data['email']= business.facebooks.first.email
data['password']  = business.facebooks.first.password
data['business']	= business.business_name
data['website']		= business.company_website
data[ 'business' ] 				= business.business_name
data[ 'zip' ] 					= business.zip
data[ 'phone' ] 				= business.local_phone
data[ 'address' ] 				= business.address
data[ 'city' ]					= business.city
data[ 'state' ]  				= business.state
data['location']				= data['city']+', '+data['state']
data[ 'website'] 				= business.company_website
data[ 'business_description' ] 	= business.business_description
catty 							= Facebook.where(:business_id => business.id).first
data['category']				= catty.facebook_category.name
monthname = Date::MONTHNAMES[business.birthday.month]
data[ 'birth_month' ] 			= monthname[0..2]
data[ 'birth_day' ] 			= business.birthday.day
data[ 'birth_year' ] 			= business.birthday.year

data
