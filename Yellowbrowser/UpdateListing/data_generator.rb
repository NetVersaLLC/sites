data = {}
data[ 'first_name' ]	= business.contact_first_name
data[ 'last_name' ]	= business.contact_last_name
data[ 'fullname' ]	= data[ 'first_name' ] + ' ' + data[ 'last_name' ]
data[ 'category1' ]	= business.category1
data[ 'category2' ]	= business.category2
data[ 'category3' ]	= business.category3
data[ 'state' ]	= business.state
data[ 'city' ]	= business.city
data[ 'business' ]	= business.business_name
data[ 'address' ]	= business.address + business.address2
data[ 'zip' ]	= business.zip
data[ 'phone' ]	= business.local_phone
data[ 'fax' ]	= business.fax_number
data[ 'email' ]	= business.bings.first.email
data[ 'website' ]	= business.company_website
data[ 'description' ]	= business.business_description
data[ 'category' ]	= business.category1 + " " + business.category2 + " " + business.category3
data['reason_for_update'] = 'Business Update'
data


