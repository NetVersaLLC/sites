data = {}
catty                       = Digabusiness.where(:business_id => business.id).first
catty 						= DigabusinessCategory.find(catty.category_id)
data[ 'category1' ]         = catty.parent.name.chomp
data[ 'category2' ]         = catty.name.chomp

data['password']		= business.digabusinesses.first.password
data[ 'email' ]			= business.digabusinesses.first.email

data[ 'business' ]		= business.business_name
data[ 'website' ]		= business.company_website
data[ 'description' ]	= business.business_description
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'fullname' ]		= data[ 'fname' ] + ' ' + data[ 'lname' ]
data[ 'addressComb' ]	= business.address + "  " + business.address2
data[ 'city' ]			= business.city
data[ 'state_name' ]	= business.state_name
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'payments' ]		= Digabusiness.payment_methods(business)
data
