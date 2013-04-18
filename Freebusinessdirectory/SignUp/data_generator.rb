data = {}
seed = rand(10000).to_s()
data[ 'business' ]		= business.business_name
data[ 'firstname' ]		= business.contact_first_name
data[ 'lastname' ]		= business.contact_last_name
data[ 'email' ]			= business.bings.first.email
data[ 'userid' ]		= business.bings.first.email[0 .. 15].gsub("@","")
data[ 'password' ]		= Yahoo.make_password
data
