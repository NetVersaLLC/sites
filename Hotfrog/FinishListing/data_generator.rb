data = {}
data['email']		= business.bings.first.email
data['password']	= business.hotfrogs.first.password
data['fax']			= business.fax_number
data['phone']		= business.local_phone
data['payments']	= Hotfrog.payment_methods(business)
data['24hours']		= business.open_24_hours
data['hours']		= Localndex.get_hours(business)
data