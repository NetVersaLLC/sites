data = {}
foursq                  = business.foursquares.first
data['password']        = foursq.password
data['email']           = business.bings.first.email

data