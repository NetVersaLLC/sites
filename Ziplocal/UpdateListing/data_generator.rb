data = {}
data[ 'phone' ] = business.local_phone 
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'email' ] = business.bings.first.email
data[ 'business_email' ] = business.bings.first.email
data[ 'business' ] = business.business_name
data[ 'streetnumber' ] = business.address + ' ' + business.address2
data[ 'city' ] = business.city
data[ 'state' ] = business.state_name
data[ 'stateabreviation' ] = business.state
data[ 'zip' ] = business.zip
data[ 'country' ] = 'United States'
data[ 'countryAbrv' ] = 'US'
data[ 'citystate' ] = data[ 'city' ] + ', ' + data[ 'stateabreviation' ]
data[ 'new_password' ] = Yahoo.make_password
data[ 'website' ] = business.company_website
data[ 'prefix' ] = business.contact_prefix
catty = Ziplocal.where(:business_id => business.id).first
data[ 'categoryKeyword' ] = ZiplocalCategory.find(catty.category_id).name
data[ 'password'] = catty.password
data[ 'heap' ] = catty.heap
data
