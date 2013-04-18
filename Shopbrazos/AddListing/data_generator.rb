data = {}
data['fname']			= business.contact_first_name
data['lname']			= business.contact_last_name
data['address']			= business.address + ' ' + business.address2
data['city']			= business.city
data['state']			= business.state
data['zip']			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'areacode' ]		= business.local_phone.split("-")[0]
data[ 'exchange' ]		= business.local_phone.split("-")[1]
data[ 'last4' ]			= business.local_phone.split("-")[2]
data[ 'email' ]			= business.bings.first.email
data[ 'business' ]		= business.business_name
data[ 'website' ]		= business.company_website
data
