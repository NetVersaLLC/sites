data = {}
seed = rand( 1000 ).to_s()
data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
data[ 'phone' ]        	    = business.local_phone
data[ 'email' ]		    = business.bings.first.email
data[ 'business' ]	    = business.business_name
data[ 'website' ] 	    = business.company_website.gsub("http://", "")
data[ 'description' ] 	    = business.business_description + business.category1 + ", " + business.category2 + ", " + business.category3 + ", " + business.category4 + ", " + business.category5
data[ 'title' ] 	    = business.category1 + ' ' + business.category2
data[ 'address' ] 	    = business.address + ' ' +business.address2 + '#47'
data[ 'city' ] 		    = business.city
data[ 'state' ] 	    = business.state_name
data[ 'zip' ] 	 	    = business.zip
data[ 'country' ]  	    = 'United States'
data[ 'image' ]  	    = business.logo_file_name
data[ 'password' ] 	    = Yahoo.make_password
data

 
