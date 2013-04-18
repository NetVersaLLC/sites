data = {}
catty = Foursquare.where(:business_id => business.id).first
data[ 'category_first' ]    = catty.digabusiness_category.parent.name
data[ 'category_second' ]   = catty.digabusiness_category.name

data[ 'username' ]			= business.foursquares.first.email
data[ 'password' ]			= business.foursquares.first.password
data[ 'name' ]   	    	= business.business_name
data[ 'zip' ]      	    	= business.zip
data[ 'state' ]    	    	= business.state
data[ 'city' ]     	    	= business.city
data[ 'phone' ]				= business.local_phone
data[ 'address' ]			= business.address + ", " + business.address2
data[ 'crossstreet' ]		= "Nth and Yth"
data[ 'country' ]			= "United States"
data[ 'twitter' ]			= #business.twitters.first.username
data
