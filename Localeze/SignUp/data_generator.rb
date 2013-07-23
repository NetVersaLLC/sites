data = {}

catty                       = Localeze.where(:business_id => business.id).first
data[ 'category' ]          = catty.localeze_category.name.gsub("\n", "")

data[ 'phone' ]     	    = "704-817-3921"#business.local_phone
data[ 'phone_area' ]        = "704"#business.local_phone.split("-")[1]
data[ 'phone_prefix' ]      = "817"#business.local_phone.split("-")[2]
data[ 'phone_suffix' ]      = "3921"#business.local_phone.split("-")[3]
data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
data[ 'email' ]             = business.bings.first.email
data[ 'city' ]     	   		= business.city
data[ 'state' ]    	    	= business.state + ' - ' + business.state_name
data[ 'zip' ]      	    	= business.zip
data[ 'address' ]  	    	= business.address + ' ' + business.address2
data[ 'business' ]   	    = business.business_name
data['associated_as'] 	    = 'Owner'
data[ 'department' ]  	    = business.category1
data['username']			= business.contact_first_name[0..2] + business.contact_last_name[0..2] + rand(100).to_s
data['password']			= Yahoo.make_password + rand(100).to_s
data


