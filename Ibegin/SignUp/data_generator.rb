data = {}
seed = rand(10000).to_s()
data[ 'username' ]		= business.contact_first_name + business.contact_last_name + seed
data[ 'email' ]			= business.bings.first.email
data[ 'password' ]		= Yahoo.make_password[0 .. 8]
data
