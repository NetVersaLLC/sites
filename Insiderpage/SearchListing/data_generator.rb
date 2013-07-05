data = {}
data['email']     = business.insider_pages.first.email
data['password']  = business.insider_pages.first.password
data['firstname'] = business.contact_first_name
data['near_city'] = business.city + ', ' + business.state
data['business']  = business.business_name
data
