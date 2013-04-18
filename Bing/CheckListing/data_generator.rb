data = {}
data[ 'name' ]              = business.business_name
data[ 'city' ]              = business.city
data[ 'state_short' ]       = business.state
data[ 'hotmail' ]           = business.bings.first.email
data[ 'password' ]          = business.bings.first.password
data
