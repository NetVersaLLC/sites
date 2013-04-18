data = {}
catty                       = Yellowee.where(:business_id => business.id).first
data['password']		= business.yellowees.first.password
data['email']			= business.yellowees.first.username
data[ 'business' ]		= business.business_name
data[ 'query' ]			= business.city + ", " + business.state + ", United States"
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'website' ]		= business.company_website

data['cat1'] = catty.yellowee_category.parent.name
data['cat2'] = catty.yellowee_category.name

data[ 'hours' ]			= Justclicklocal.get_hours( business )
data[ 'description' ]		= business.business_description
data[ 'founded' ]		= business.year_founded
data