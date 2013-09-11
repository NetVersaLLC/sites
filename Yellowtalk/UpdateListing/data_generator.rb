data = {}
catty = Yellowtalk.where(:business_id => business.id).first
data[ 'phone' ] = business.local_phone
data[ 'username' ] = business.yellowtalks.first.username
data[ 'email' ] = business.bings.first.email 
data['category'] = catty.yellowtalk_category.name.gsub("\r\n","")
data[ 'business' ] = business.business_name
data[ 'address' ] = business.address + ' ' + business.address2
data[ 'city' ] = business.city
data[ 'state' ] = business.state 
data[ 'zip' ] = business.zip
data[ 'business_description'] = business.business_description
data[ 'website'] = business.company_website
data[ 'role' ] = 'owner'
data[ 'name_title' ] = business.contact_prefix
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'password' ] = business.yellowtalks.first.password
data[ 'reason_for_info_update'] = ''
data[ 'fax' ] = business.fax_number
data