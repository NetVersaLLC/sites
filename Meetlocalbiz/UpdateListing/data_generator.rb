data = {}
seed = rand(100000).to_s
catty = Meetlocalbiz.where(:business_id => business.id).first 
data['category']			= catty.meetlocalbiz_category.name
data['firstname']			= business.contact_first_name
data['lastname']			= business.contact_last_name
data['firstlast']			= data['firstname']+" "+data['lastname']
data['business']			= business.business_name
data['address']				= business.address
data['address2']			= business.address2
data['city']				= business.city
data['state']				= business.state
data['phone']				= business.local_phone
data['altphone']			= business.alternate_phone
data['fax']					= business.toll_free_phone
data['username']			= business.meetlocalbizs.first.username + "@outlook.com"
data['password']			= business.meetlocalbizs.first.password
data['zip']					= business.zip
data['hours']				= Getfave.consolidate_hours(business)
data['website']				= business.company_website
data