data = {}
data[ 'phone' ] = business.local_phone
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'email' ] = business.bings.first.email
data[ 'business' ] = business.business_name
data[ 'streetnumber' ] = business.address + ' ' + business.address2
data[ 'city' ] = business.city
data[ 'state' ] = business.state_name
data[ 'stateabreviation' ] = business.state
data[ 'zip' ] = business.zip
data[ 'country' ] = 'United States'
data[ 'countryAbrv' ] = 'US'
data[ 'citystate' ] = data[ 'city' ] + ', ' + data[ 'stateabreviation' ]
data[ 'password' ] = Yahoo.make_password
data[ 'short_desc' ] = business.category1 + ' ' + business.category2 + ' ' + business.category3 + ' ' + business.category4 + ' ' + business.category5
data[ 'description' ] = business.business_description
data
