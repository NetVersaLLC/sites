data = {}
seed = rand(1000).to_s
data['username']		= business.bings.first.email
data['email']			= business.bings.first.email
data['password']		= Yahoo.make_password
data