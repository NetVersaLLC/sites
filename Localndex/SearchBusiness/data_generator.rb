data = {}
data['phone']			= business.local_phone.gsub("-", "")
data['email']			= business.bings.first.email
data['password']		= Yahoo.make_password
data
