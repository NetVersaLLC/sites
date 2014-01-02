data = {}
data[ 'email' ]           = business.googles.first.email
data[ 'pass' ]            = business.googles.first.password
data[ 'business' ]        = business.business_name
data[ 'zip' ]             = business.zip.to_i
data[ 'name' ]            = business.contact_first_name + " " + business.contact_last_name
data[ 'phone' ]           = business.local_phone
data[ 'state' ]           = business.state_name
data[ 'address' ]         = business.address
data[ 'hours'   ]         = Google.get_hours(business)
data[ 'city' ]		= business.city
data[ 'website'] 	= business.company_website
data[ 'description'] = business.business_description
catty = Facebook.where(:business_id => business.id).first
data['category']	= GoogleCategory.find(catty.category_id).name
data['country'] = 'United States'
data[ 'fax' ] = business.fax_number
data[ 'mobile?' ] = business.mobile_appears
data[ 'mobile' ] = business.mobile_phone
data
