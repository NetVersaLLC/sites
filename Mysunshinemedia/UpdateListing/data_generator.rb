data = {}
data[ 'phone' ] = business.local_phone
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'email' ] = business.bings.first.email
data[ 'business_email' ] = business.bings.first.email
data[ 'business' ] = business.business_name
data[ 'website' ] = business.company_website
catty 			= Ziplocal.where(:business_id => business.id).first
data[ 'categoryKeyword' ] = ZiplocalCategory.find(catty.category_id).name
data
