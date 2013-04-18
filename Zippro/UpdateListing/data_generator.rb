data = {}
data['email']				= business.zippros.first.username
data['password']			= business.zippros.first.password
data['business']			= business.business_name
data['address']				= business.address
data['address2']			= business.address2
data['city']				= business.city
data['zip']					= business.zip
data['state_name']			= business.state_name
data['payments']			= Zippro.payment_methods(business)
data