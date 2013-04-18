data = {}
data[ 'business' ]		= business.business_name
data[ 'address' ]		= business.address + " " + business.address2
data[ 'city' ]			= business.city
data[ 'state' ]			= business.state
data[ 'phone' ]			= business.local_phone
data[ 'tollfree' ]		= business.toll_free_phone
data[ 'email' ]			= business.bings.first.email
data['website']			= business.company_website
data['zip']			= business.zip
data
