data = {}
data[ 'business' ]          = business.business_name
data[ 'city' ]              = business.city
data[ 'state_short' ]       = business.state
data[ 'citystate' ] = data[ 'city' ] + ", " + data[ 'state_short' ]
data[ 'query' ] = data[ 'business' ] + " " + data[ 'citystate' ]
data[ 'phone' ]             = business.local_phone

data[ 'phone_area' ] = business.local_phone.split("-")[0]
data[ 'phone_prefix' ] = business.local_phone.split("-")[1]
data[ 'phone_suffix' ] = business.local_phone.split("-")[2]
data[ 'zip' ]       = business.zip
data