
data = {}
data[ 'phone' ] = business.local_phone
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'email' ] = business.manta.first.email
data[ 'business' ] = business.business_name
data[ 'address' ] = business.address + ' ' + business.address2
data[ 'address1' ] = business.address
data[ 'city' ] = business.city
data[ 'state' ] = business.state_name
data[ 'stateabreviation' ] = business.state
data[ 'zip' ] = business.zip
data[ 'country' ] = 'United States'
data[ 'countryAbrv' ] = 'US'
data[ 'citystate' ] = data[ 'city' ] + ', ' + data[ 'stateabreviation' ]
data[ 'password' ] = business.manta.first.password
data[ 'short_desc' ] = business.category_description
data[ 'description' ] = business.business_description
data[ 'category' ] = business.category1
data
