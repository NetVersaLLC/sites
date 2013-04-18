data = {}
seed = rand(1000)
data['fname']			= business.contact_first_name
data['username']		= business.business_name.gsub(" ", "") + seed.to_s
data['email']			= business.bings.first.email
data['password']		= Yahoo.make_password
data['secret_answer']	= Yahoo.make_secret_answer1
data