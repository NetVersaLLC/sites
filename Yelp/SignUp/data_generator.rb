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

data['category'] 		= catty.yelp_category.name

begin 
data['parent']			= catty.yelp_category.parent.name
rescue
	data['parent']			= ""
end

begin
	data['rootcat'] 		= catty.yelp_category.parent.parent.name
rescue
	data['rootcat'] 		= ""
end

data
