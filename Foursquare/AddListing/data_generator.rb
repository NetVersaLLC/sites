data = {}
data[ 'phone' ]			= business.local_phone
data[ 'mobile' ]	    = business.mobile_phone
data[ 'first_name' ]    = business.contact_first_name
data[ 'last_name' ]     = business.contact_last_name
data[ 'email' ]         = business.bings.first.email
data[ 'city' ]     	    = business.city
data[ 'state' ]    	    = business.state
data[ 'zip' ]      	    = business.zip
data[ 'address']        = business.address + 
                           (((business.address2 || '') != '') ? ", #{business.address2}" : '')
data[ 'business_name' ] = business.business_name
data[ 'associated_as'] 	= 'Owner'
data[ 'birth_month' ]   = business.contact_birthday.split("/")[0]
data[ 'birth_day' ]	    = business.contact_birthday.split("/")[1]
data[ 'birth_year' ]    = business.contact_birthday.split("/")[2]

data['twitter_page']    = business.twitters.first.nil? ? '' : business.twitters.first.twitter_page

foursq                  = business.foursquares.first
catty                   = FoursquareCategory.find(foursq.category_id)
data['category1']       = catty.name
data['category2']       = catty.parent.name

data['password']        = foursq.password
data['email']           = business.bings.first.email

data