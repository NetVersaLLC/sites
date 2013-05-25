data = {}
data[ 'business' ]          = business['name']
data[ 'zip' ]               = business['zip']
data[ 'country']			= 'USA'
data[ 'businessfixed' ]          = data['business'].gsub(" ", "%20")
data