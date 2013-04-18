data = {}
data[ 'phone' ] = business.local_phone
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'email' ] = business.bings.first.email
data[ 'business_email' ] = business.bings.first.email
data[ 'business' ] = business.business_name
data[ 'website' ] = business.company_website
data[ 'categoryKeyword' ] = business.category1 + ' ' + business.category2 + ' ' + business.category3 + ' ' + business.category4 + ' ' + business.category5
data
