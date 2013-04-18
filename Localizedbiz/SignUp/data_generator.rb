data = {}
seed = rand(10000).to_s
data[ 'username' ]		= business.bings.first.email[0..8] + seed
data[ 'password' ]		= Yahoo.make_password
data[ 'email' ]		= business.bings.first.email
data
