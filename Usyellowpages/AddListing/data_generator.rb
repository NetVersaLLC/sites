data = {}

data['email']				= business.usyellowpages.first.email
data['password']			= business.usyellowpages.first.password

data['business']			= business.business_name
data['address']				= business.address + " " + business.address2
data['zip']					= business.zip

catty 						= Usyellowpages.where(:business_id => business.id).first
data['category']			= catty.usyellowpages_category.name

data['phone']				= business.local_phone
data['areacode']			= data['phone'].split("-")[0]
data['prefix']				= data['phone'].split("-")[1]
data['suffix']				= data['phone'].split("-")[2]

data[ 'hours' ]				= Usyellowpages.consolidate_hours(business)
data['payments']			= Usyellowpages.payment_methods(business)
data
