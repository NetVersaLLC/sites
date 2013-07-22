data = {}
data[ 'business' ]          = business['business_name']
data[ 'businessfixed' ]      = business['business_name'].gsub(" ","+").gsub(",","")
data['city']                   = business.city.gsub(" ", "+")
data['state']                   = business.state
data