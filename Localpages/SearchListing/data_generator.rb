data = {}
data[ 'business' ]          = business['business']
data[ 'city' ]              = business['city']
data[ 'state_short' ]       = business['state_short']
data[ 'businessfixed' ]          = data['business'].gsub(" ", "-")
data