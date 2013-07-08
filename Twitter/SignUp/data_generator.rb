data = {}
seed = rand(1000).to_s
data['fname']		= business.contact_first_name
data['lname']		= business.contact_last_name
data['fullname']	= data['fname']+" "+data['lname']
data['email']		= business.bings.first.email
data['username']	= business.business_name.gsub(/[^0-9A-Za-z]/, '')
data['password']	= Yahoo.make_password
data
