data = {}
catty = Shopcity.where(:business_id => business.id).first
data[ 'category1' ]          = catty.shopcity_category.name
data[ 'email' ]			= business.shopcities.first.username
data[ 'password' ]		= business.shopcities.first.password
data[ 'state' ]			= business.state_name
data[ 'city' ]			= business.city
data[ 'state_name' ]	= business.state_name
data[ 'city' ]			= business.city
data[ 'business' ]		= business.business_name
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'fax' ]			= business.fax_number
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'fullname' ]		= data[ 'fname' ] + ' ' + data[ 'lname' ]
data[ 'phone' ]			= business.local_phone
data[ 'payments' ]		= Shopcity.payment_methods(business)
data[ 'country' ]		= "United States"
data[ 'cityState' ]		= data['city'] + ", " + data['state']
data