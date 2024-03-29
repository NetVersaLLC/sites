data = {}
data[ 'heap'] = business.magicyellows.first.heap
data[ 'business_category' ] = MagicyellowCategory.find(business.magicyellows.first.category_id).name
data[ 'phone' ] = business.local_phone
data[ 'email' ] = business.bings.first.email
data[ 'password' ] = business.magicyellows.first.password
data[ 'business' ] = business.business_name
data[ 'address' ] = business.address
data[ 'city' ] = business.city
data[ 'state' ] = business.state_name
data[ 'zip' ] = business.zip
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'claim_business'] = 'yes'
data[ 'fullname' ] = data[ 'first_name' ] + " " + data[ 'last_name' ]
data[ 'business_description']  = (business.business_description + business.category_description)[0..200]
data[ 'payment_option'] = Magicyellow.payments(business)
data[ 'relation_to_business' ] = 'Agent'
data[ 'is_owner'] = 'Yes'
data[ 'additional_services' ] = business.services_offered
data[ 'additional_products' ] = ' '
data[ 'additional_brands' ] = business.brands
data['bing_password'] = business.bings.first.password
data
