data = {}
catty = Yelp.where(:business_id => business.id).first
data[ 'name' ]			= business.business_name
data[ 'city' ]			= business.city
data[ 'state' ]			= business.state
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'website' ]		= business.company_website
data[ 'email' ]			= business.bings.first.email

data[ 'cat1' ] = catty.yelp_category.parent.name.gsub("\n", "")
data[ 'cat2' ] = catty.yelp_category.name.gsub("\n", "")
data
