data = {}
data['password']		= business.digabusinesses.first.password
data['email' ]			= business.digabusinesses.first.email
data['username']		= business.digabusinesses.first.username

data[ 'business' ]		= business.business_name
data[ 'website' ]		= business.company_website
data[ 'description' ]	= business.business_description
data[ 'category_id' ]           = Digabusiness.where(:business_id => business.id).first.id
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'fullname' ]		= data[ 'fname' ] + ' ' + data[ 'lname' ]
data[ 'addressComb' ]	= business.address + "  " + business.address2
data[ 'city' ]			= business.city
data[ 'state_name' ]	= business.state_name
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'payments' ]		= Digabusiness.payment_methods(business)
data[ 'services' ]              = business.services_offered
data
