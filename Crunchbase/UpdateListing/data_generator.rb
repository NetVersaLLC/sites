data = {}
data['email']		= business.crunchbases.first.email
data['password']	= business.crunchbases.first.password
data['business']		= business.business_name
data['description']		= business.business_description
data['category']		= #TODO
data['url']				= business.company_website
data['phone']			= business.local_phone
data['yearfounded']		= business.year_founded
data['tags']			= business.category1 + ', ' + business.category2 + ', ' + business.category3 + ', ' + business.category4 + ', ' + business.category5
data