data = {}
data[ 'phone' ]	 = business.local_phone
data[ 'email' ] = business.bings.first.email
data[ 'business' ] = business.business_name
data[ 'address' ] = business.address + "  " + business.address2
data[ 'first_name' ] = business.contact_first_name 
data[ 'last_name' ] = business.contact_last_name
data[ 'full_name' ] = data[ 'first_name' ] + " " + data[ 'last_name' ]
data[ 'country' ] = 'United States'
data[ 'continent' ] = 'North America'
data[ 'city' ] = 'Hawaii'
data[ 'password' ]	= Yahoo.make_password
data[ 'category' ] = 'Entertainment'
data
