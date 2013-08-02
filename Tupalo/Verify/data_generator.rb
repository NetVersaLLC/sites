data = {}
data[ 'pass' ] 				= Tupalo.check_email(business)
data[ 'email' ]				= business.tupalos.first.email
data[ 'password' ]			= business.tupalos.first.password
data