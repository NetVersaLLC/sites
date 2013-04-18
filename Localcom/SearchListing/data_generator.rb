data = {}
data[ 'business' ]          = business.business_name
data[ 'city' ]              = business.city
data[ 'state_short' ]       = business.state
data[ 'businessfixed' ]          = data['business'].gsub(" ", "%20")
data