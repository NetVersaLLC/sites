data = {}
seed = rand(10000).to_s()
data[ 'business_name' ]		= business.business_name
data[ 'contact_first_name' ]= business.contact_first_name
data[ 'contact_last_name' ]	= business.contact_last_name
data[ 'email' ]				= business.bings.first.email
data[ 'userid' ]			= [business.bings.first.email[0 .. 15].gsub("@",""),Random.rand(1000..9999)].join
data[ 'password' ]			= Yahoo.make_password
data
