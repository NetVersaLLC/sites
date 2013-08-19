data = {}
seed = rand(100000).to_s
catty = Meetlocalbiz.where(:business_id => business.id).first 
data['category']			= catty.meetlocalbiz_category.name
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