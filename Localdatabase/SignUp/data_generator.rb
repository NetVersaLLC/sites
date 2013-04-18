data = {}
data['username'] 	= business.bings.first.email.split("@")[0] + 9.to_s
data['email'] 	= business.bings.first.email
data['password'] 	= Yahoo.make_password
data['type'] 		= 'owner'
data
