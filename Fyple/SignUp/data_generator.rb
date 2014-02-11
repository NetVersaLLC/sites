data = {}
seed = rand(10000).to_s()
data[ 'email' ]			   = business.bings.first.email
data[ 'bing_password'] = business.bings.first.password
data[ 'password' ]		 = Yahoo.make_password[0 .. 8]
data[ 'name'] = business.contact_first_name + ' ' + business.contact_last_name
data
