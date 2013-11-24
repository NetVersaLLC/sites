data = {}
data[ 'email' ]			= business.bings.first.email
data[ 'username' ]		= data['email'].split("@")[0]
data[ 'password' ]		= business.bings.first.password
data
