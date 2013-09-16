data = {}
data['username'] 	= business.bings.first.email.split("@")[0] + rand(9999)
data['email'] 		= business.bings.first.email
data['password'] 	= Yahoo.make_password
data['fname']		= business.contact_first_name
data['lname']		= business.contact_last_name
data