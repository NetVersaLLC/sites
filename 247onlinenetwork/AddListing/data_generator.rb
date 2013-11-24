data = {}
data[ 'gender' ] = business.contact_gender == "Male" ? "Mr." : "Ms."
data[ 'firstname' ] = business.contact_first_name
data[ 'lastname' ] = business.contact_last_name
data[ 'business_phone' ] = business.mobile_phone
data[ 'email' ] = business.bings.first.email
data[ 'business_name' ] = business.business_name
data[ 'address' ] = business.address
data[ 'city' ] = business.city
data[ 'state' ] = business.state
data[ 'zip' ] = business.zip
data[ 'website' ] = business.company_website
data[ 'business_description' ] = business.business_description
data
