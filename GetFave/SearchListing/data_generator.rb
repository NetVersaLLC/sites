data = {}
data['business']      = business.business_name
data['city']          = business.city
data['state_short']   = business.state
data['businessfixed'] = business.business_name.gsub(" ", "+")
data['cityfixed']     = business.city.gsub(" ", "+")
data