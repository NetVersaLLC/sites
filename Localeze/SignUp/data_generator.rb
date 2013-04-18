data = {}

catty                       = Localeze.where(:business_id => business.id).first
data[ 'category' ]          = catty.localeze_category.parent.name.gsub("\n", "")

data[ 'phone' ]     	    = business.local_phone
data[ 'phone_area' ]        = business.local_phone.split("-")[1]
data[ 'phone_prefix' ]      = business.local_phone.split("-")[2]
data[ 'phone_suffix' ]      = business.local_phone.split("-")[3]
data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
data[ 'email' ]             = business.bings.first.email
data[ 'city' ]     	    = business.city
data[ 'state' ]    	    = business.state + ' - ' + business.state_name
data[ 'zip' ]      	    = business.zip
data[ 'address' ]  	    = business.address + ' ' + business.address2
data[ 'business' ]   	    = business.business_name
data['associated_as'] 	    = 'Owner'
data[ 'department' ]  	    = business.category1
data


