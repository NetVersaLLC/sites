data = {}
data[ 'business' ]          = business['business']
data[ 'businessfixed' ]          = business['business'].gsub(" ", "+").gsub("-","+")
data['zip']   = business['zip']
data