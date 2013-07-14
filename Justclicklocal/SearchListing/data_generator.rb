data = {}
data[ 'business' ]          = business['business_name']
data[ 'businessfixed' ]     = data[ 'business' ].gsub(" ","-").gsub("&","")
data[ 'city' ]              = business['city']
data[ 'state' ]       = business['state']
data