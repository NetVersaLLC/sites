data = {}
data[ 'name' ]         = business.business_name
data[ 'city' ]         = business.city
data[ 'state_short' ]  = business.state
data[ 'address' ]      = business.address + " " + business.address2
data[ 'zip' ]          = business.zip
data[ 'phone' ]        = business.local_phone
data[ 'hotmail' ]      = business.bings.first.email
data[ 'password' ]     = business.bings.first.password
data[ 'secret_answer' ]= business.bings.first.secret_answer
data
