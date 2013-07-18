data = {}
data['business'] 	= business.business_name
data['description'] = business.business_description
data['street'] 		= business.address + ' ' + business.address2
data['city'] 		= business.city
data['state'] 		= business.state
data['zip'] 		= business.zip
data['keywords'] 	= business.keywords.split(",")
data['email']		= business.bings.first.email
data['password']	= business.hotfrogs.first.password
data['website'] 	= business.company_website
data['fax']			= business.fax_number
data['phone']		= business.local_phone
data['payments']	= Hotfrog.payment_methods(business)
data['24hours']		= business.open_24_hours
data['hours']		= Localndex.get_hours(business)
data