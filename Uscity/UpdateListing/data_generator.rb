data = {}
data['email']					= business.uscities.first.email
data['password']				= business.uscities.first.password
data[ 'first_name' ]	  		= business.contact_first_name
data[ 'last_name' ]	  			= business.contact_last_name
data[ 'full_name' ]	  			= data[ 'first_name' ] +' '+ data[ 'last_name' ] 
data[ 'business' ]        		= business.business_name
data[ 'zip' ]             		= business.zip
data[ 'phone' ]           		= business.local_phone.gsub("-", "")
data[ 'address' ]         		= business.address
data[ 'city' ]	 				= business.city
data[ 'website'] 				= business.company_website
data[ 'business_description' ]  = business.business_description
data['state']					= business.state_name
catty 							= Uscity.where(:business_id => business.id).first
data[ 'category' ] 				= catty.uscity_category.name

data