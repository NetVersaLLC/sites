data = {}
data[ 'phone_area' ]    = business.local_phone.split("-")[0]
data[ 'phone_prefix' ]  = business.local_phone.split("-")[1]
data[ 'phone_suffix' ]  = business.local_phone.split("-")[2]
data[ 'phone' ]			= data[ 'phone_area' ] + data[ 'phone_prefix' ] + data[ 'phone_suffix' ]
data[ 'first_name' ]    = business.contact_first_name
data[ 'last_name' ]     = business.contact_last_name
data[ 'email' ]         = business.bings.first.email
data[ 'city' ]     	    = business.city
data[ 'state' ]    	    = business.state #need abreviation
data[ 'zip' ]      	    = business.zip
data[ 'address' ]  	    = business.address + ' ' + business.address2
data[ 'business' ]   	= business.business_name
data[ 'associated_as'] 	= 'Owner'
data[ 'category' ]  	= business.category1
data[ 'department' ]  	= business.category2
data[ 'name' ]		    = business.business_name
monthNumber				= business.contact_birthday.split("/")[0]
data[ 'birth_month' ]	= Date::MONTHNAMES[monthNumber.to_i]
data[ 'birth_day' ]		= business.contact_birthday.split("/")[1]
data[ 'birth_year' ]	= business.contact_birthday.split("/")[2]
data[ 'password' ]		= business.bings.first.password
data[ 'logo' ]			= "C:\\1.jpg"#business.logo_file_name

data
