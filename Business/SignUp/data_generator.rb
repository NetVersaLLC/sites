data = {}
data[ 'phone' ]     	    = business.local_phone
data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
data[ 'email' ]             = business.bings.first.email
data[ 'city' ]     	    = business.city
data[ 'state' ]    	    = business.state
data[ 'zip' ]      	    = business.zip
data[ 'address' ]  	    = business.address + ' ' + business.address2
data[ 'company_url' ] 	    = business.company_website
data[ 'company_name' ] 	    = business.business_name
data[ 'description' ] 	    = business.business_description
data[ 'company_type' ] 	    = 'Private'
data[ 'title' ] 	    = 'Owner'
data[ 'no_of_employees' ]   = '5 to 9'
data[ 'password' ]	    = Yahoo.make_password
time = Time.new
data[ 'years_in_business' ] = time.year.to_i - business.year_founded.to_i
data[ 'office_footage' ]    = "47"
data[ 'annua_sales' ]       = "500k to 1m"
data[ 'category' ]    	    = 'Business Consulting'
data[ 'sub_category' ]      = 'Corporate Culture Consultants'
data['office_footage']	    = '0 to 2,499'
data

