data = {}
data[ 'business' ]		= business.business_name
data[ 'query' ]			= business.city + ", " + business.state
data[ 'firstname' ]		= business.contact_first_name
data[ 'lastname' ]		= business.contact_last_name
data[ 'phone1' ]		= business.local_phone.split("-")[0]
data[ 'phone2' ]		= business.local_phone.split("-")[1]
data[ 'phone3' ]		= business.local_phone.split("-")[2]
data[ 'email' ]			= business.bings.first.email
data[ 'password' ]		= Yahoo.make_password
data
