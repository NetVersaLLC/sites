data = {}
data[ 'business' ]		= business.business_name
data[ 'first_name' ]		= business.contact_first_name
data[ 'last_name' ]		= business.contact_last_name
data[ 'phone' ]			= business.local_phone
data[ 'address' ]		= business.address + ' ' + business.address2
data[ 'city' ]			= business.city
data[ 'zip' ]			= business.zip
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website
data[ 'state' ]			= business.state_name
data[ 'category' ]		= business.category1 + ', ' + business.category2 + ', ' + business.category3 + ', ' + business.category4 + ', ' + business.category5
data
