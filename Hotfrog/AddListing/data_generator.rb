data ={}
data[ 'business'] = business.business_name
data[ 'address' ] = business.address + ' ' + business.address2
data[ 'city' ] = business.city
data[ 'state' ] = business.state
data[ 'zip' ] = business.zip
data[ 'email' ] = business.bings.first.email
data[ 'website' ] = business.company_website
data[ 'business_description'] = business.business_description
data[ 'keywords'] = business.keywords
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'job_title'] = 'Business owner or senior management'
data[ 'password'] = Yahoo.make_password
data
