data = {}
data['business']      = business.business_name
data['businessfixed'] = data['business'].gsub(" ", "+")
data['zip']           = business.zip
data