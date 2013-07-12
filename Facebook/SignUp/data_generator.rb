data = {}
data[ 'email' ] = business.bings.first.email
data[ 'password' ] = business.googles.first.password
data[ 'business' ] = business.business_name
data[ 'zip' ] = business.zip
data[ 'phone' ] = business.local_phone
data[ 'address' ] = business.address
data[ 'city' ]	= business.city
data[ 'state' ]  = business.state
data[ 'website'] = business.company_website
data[ 'business_description' ] = business.business_description
data['category']	= business.category1
data[ 'birth_month' ] = business.birthday.month
data[ 'birth_day' ] = business.birthday.day
data[ 'birth_year' ] = business.birthday.year
data['logo'] = ContactJob.logo
data
