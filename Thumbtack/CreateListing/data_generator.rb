data = {}
data[ 'first_name' ]       	= business.contact_first_name
data[ 'last_name' ]       	= business.contact_last_name
data[ 'phone' ]        	   	= business.local_phone
data[ 'email' ]		    = business.thumbtacks.first.email
data[ 'business' ]	    = business.business_name
data[ 'website' ] 		= business.company_website
data[ 'description' ] 	= business.business_description
data[ 'title' ] 		= business.category1 + ' ' + business.category2
data[ 'address' ] 		= business.address + ' ' +business.address2
data[ 'city' ] 		    = business.city
data[ 'state' ] 	    = business.state_name
data[ 'zip' ] 	 	   	= business.zip
data[ 'country' ]  	    = 'United States'
data[ 'image' ]  	    = business.logo_file_name
data[ 'password' ]	    = business.thumbtacks.first.password
data[ 'url' ]			= Thumbtack.check_email(business)
data
