data = {}
data['username']		= business.gomylocals.first.username
data['password']		= business.gomylocals.first.password
catty = Gomylocal.where(:business_id => business.id).first
data[ 'category1' ]		= catty.gomylocal_category.name
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'addressComb' ]	= business.address + "  " + business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'state_name' ]	= business.state_name
data[ 'city' ]			= business.city
data[ 'keywords' ]		= business.category1 + ", " + business.category2 + ", " + business.category3 + ", " + business.category4 + ", " + business.category5
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website
data[ 'business' ]		= business.business_name
data