data = {}
data[ 'email' ] = business.bings.first.email
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'full_name'] = data[ 'first_name' ]+data[ 'last_name' ]
data[ 'phone' ] = business.local_phone
data[ 'business' ] = business.business_name
data[ 'address' ] = business.address + ' ' + business.address2
data[ 'city' ] = business.city
data[ 'state' ] = business.state
data[ 'zip' ] = business.zip
data[ 'website' ] = business.company_website
	
data
