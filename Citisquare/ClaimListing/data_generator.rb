data = {}
data['email'] = business.bings.first.email
data['password'] = business.citisquares.first.password
data['business'] = business.business_name
data['city'] = 'Murray'
data['state'] = business.state_name
data['zip'] = business.zip
data['phone'] = business.local_phone
data['address'] = business.address
data['location'] = data['city']+", "+data['state']+", "+data['zip']
data
