data = {}
#seed = Random.new.rand(1000..2000).to_s
catty                       = Magicyellow.where(:business_id => business.id).first
data[ 'business_category' ]       = catty.magicyellow_category.name
data[ 'phone' ] = business.local_phone
data[ 'email' ] = business.bings.first.email
data[ 'business' ] = business.business_name
data[ 'address' ] = business.address
data[ 'city' ] = business.city
data[ 'state' ] = business.state_name
data[ 'zip' ] = business.zip
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'claim_business'] = 'yes'
data[ 'fullname' ] = data[ 'first_name' ] + " " + data[ 'last_name' ]
data[ 'business_description']  = (business.business_description + business.category1 + " " + business.category2 + " " + business.category3 + " " + business.category4 + " " + business.category5)[0..200]
data[ 'payment_option'] = Yahoo.payment_methods(business)
data[ 'relation_to_business' ] = 'Agent'
data[ 'is_owner'] = 'Yes'
data[ 'additional_services' ] = ' '
data[ 'additional_products' ] = ' '
data[ 'additional_brands' ] = ' '
data
