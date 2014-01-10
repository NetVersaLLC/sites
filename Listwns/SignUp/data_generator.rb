data = {}
data[ 'email' ]			= business.bings.first.email
data[ 'password' ]		= Yahoo.make_password.gsub(/[^a-zA-Z0-9]/,'')
data['business']		= business.business_name
data['phone']			= business.local_phone
data['address']			= business.address
data['category']		= ListwnsCategory.find(business.listwns.first.category_id).name
data['city']			= business.city
data['country']			= "United States"
data['zip']				= business.zip
data['description']		= business.business_description
data['keywords']		= business.category1
data
