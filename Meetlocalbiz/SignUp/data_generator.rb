data = {}
seed = rand(100000).to_s
catty = Meetlocalbiz.where(:business_id => business.id).first
catty = MeetlocalbizCategory.find(catty.category_id)
data['category']			= catty.name
data['firstname']			= business.contact_first_name
data['lastname']			= business.contact_last_name
data['business']			= business.business_name
data['address']				= business.address
data['address2']			= business.address2
data['city']				= business.city
data['state']				= business.state
data['phone']				= business.local_phone
data['email']				= business.bings.first.email
data['username']			= business.bings.first.email.split("@")[0]
data['password']			= Yahoo.make_password
data['zip']					= business.zip
data