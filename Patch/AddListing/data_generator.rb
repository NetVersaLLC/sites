data = {}
data['zip']				= business.zip
data['email']			= business.patches.first.email
data['password']		= business.patches.first.password
data['phone']			= business.local_phone
data['business']		= business.business_name
data['address']			= business.address + " " + business.address2

catty 					= Patch.where(:business_id => business.id).first
data['category1']		= catty.patch_category.parent.name
data['category2']		= catty.patch_category.name

data