data = {}
catty                   = Ezlocal.where(:business_id => business.id).first
data[ 'ezlocal_category1' ]          = catty.ezlocal_category.name.gsub("\n", "").gsub("\r","")
data['email']			= business.ezlocals.first.email
data['password']		= business.ezlocals.first.password
data['local_phone']		= business.local_phone.gsub("-","")
data['name']			= business.business_name
data['address']			= business.address
data['address2']		= business.address2
data['fax']				= business.fax_number
data['city']			= business.city
data['state_long']		= business.state_name
data['zip']				= business.zip
data['first_name']		= business.contact_first_name
data['last_name']		= business.contact_last_name
data['email']			= business.bings.first.email
data['description']		= business.business_description
data['website']			= business.company_website
data['hours']			= Ezlocal.get_hours(business)
data['payments']		= Ezlocal.payment_methods(business)
data