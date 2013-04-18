data = {}
data[ 'business' ]          = business['business']
data[ 'city' ]              = business['city']
data[ 'state_short' ]       = business['state']
data[ 'citystate' ] = data[ 'city' ] + " " + data[ 'state_short' ]
data[ 'query' ] = data[ 'business' ] + " " + data[ 'citystate' ]
data[ 'zip' ]       = business['zip']
data