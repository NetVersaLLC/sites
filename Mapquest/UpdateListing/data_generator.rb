data = {}
data['email']		= business.map_quests.first.email
data['password']	= business.map_quests.first.password
data['business'] 	= business.business_name
data['address']	 	= business.address
data['address2'] 	= business.address2
data['city']	 	= business.city
data['state']	 	= business.state
data['zip']		 	= business.zip
data['phone']	 	= business.local_phone
data['webiste']	 	= business.company_website
data['description'] = business.business_description
data['24hours']		= business.open_24_hours
data['hours']		= Localndex.get_hours(business)
data['pay_methods'] = MapQuest.payment_methods(business)
data