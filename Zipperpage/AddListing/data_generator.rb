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
data[ 'category' ]		= ZipperpageCategory.find( business.zipperpages.first.category_id ).name
data
