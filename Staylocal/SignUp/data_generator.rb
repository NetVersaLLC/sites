data = {}
data[ 'phone' ] =	 			business.local_phone
data[ 'username' ] =	 		business.bings.first.email.split("@")[0] + 9.to_s
data[ 'email' ] =	 			business.bings.first.email 
data[ 'business' ] =	 		business.business_name
data[ 'address' ] =	 			business.address + ' ' + business.address2
data[ 'city' ] =	 			business.city
data[ 'state' ] =	 			business.state 
data[ 'zip' ] =	 				business.zip
data[ 'business_description']  = business.business_description
catty = Staylocal.where(:business_id => business.id).first
data[ 'category' ] =			 catty.staylocal_category.name
data[ 'website'] =			 	business.company_website
data[ 'role' ] = 				'owner'
data[ 'first_name' ] =		 	business.contact_first_name
data[ 'last_name' ] =			business.contact_last_name
data[ 'full_name' ] =			data[ 'first_name' ] + " " + data[ 'last_name' ]
data[ 'password' ] =			Yahoo.make_password
data[ 'keywords' ] = 			business.category1 + ', ' + business.category2 + ', ' + business.category3 + ', ' + business.category4 + ', ' + business.category5
data[ 'parish' ] =			 	'Orleans Parish'
data