data = {}
data['email']				= business.mojopages.first.email
data['password']			= business.mojopages.first.password
data['name']				= business.business_name
data['description']			= business.business_description
data['phone']				= business.local_phone
data['address']				= business.address
data['citystate']			= business.city + ", " + business.state
data['zip']					= business.zip
data['url']					= business.company_website
data['keywords']			= business.category1 + ", " + business.category2 + ", " + business.category3 + ", " + business.category4 + ", " + business.category5
data