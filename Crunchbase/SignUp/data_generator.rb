data = {}
data['name'] 		= business.contact_first_name + ' ' + business.contact_last_name
data['email'] 		= business.bings.first.email
data['username'] 	= data['email'].split("@")[0]
data['password'] 	= Yahoo.make_password

data['twitter'] 	= ""#business.twitters.first.username

data['homepage'] 	= business.company_website
data['use_facebook'] 	= false
data
