data = {}


catty = Foursquare.where(:business_id => business.id).first
data[ 'category_first' ]    = catty.foursquare_category.parent.name
data[ 'category_second' ]   = catty.foursquare_category.name
data['business_url']		= business.foursquares.first.foursquare_page
data[ 'email' ]			= business.foursquares.first.email
data[ 'password' ]			= business.foursquares.first.password
data[ 'name' ]   	    	= business.business_name
data[ 'zip' ]      	    	= business.zip
data[ 'state' ]    	    	= business.state
data[ 'city' ]     	    	= business.city
data[ 'phone' ]				= business.local_phone
data[ 'address' ]			= business.address + ", " + business.address2
data[ 'crossstreet' ]		= ""
data[ 'country' ]			= "United States"
data[ 'twitter' ]			= ""#business.twitters.first.username

data
