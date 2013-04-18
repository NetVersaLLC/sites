data = {}
seed = rand(100..1000).to_s
data[ 'email' ]			= business.bings.first.email
data[ 'username' ]		= business.bings.first.email.split("@")[0]
data
