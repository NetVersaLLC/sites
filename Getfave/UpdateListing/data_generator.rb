
gf = business.getfaves.first 

data = {}
data[ 'heap' ] = (gf ? gf.heap : "{}")

data['email' ] 		= business.bings.first.email
data['new_password'] 		= Yahoo.make_password
data['bing_password'] =  business.bings.first.password
data['password'] = (gf ? gf.password : "")
data['name' ] 			= business.contact_first_name + ' ' + business.contact_last_name

data['phone'] = business.local_phone
data['address'] = business.address + ' ' + business.address2 + ', ' + business.city + ',  ' + business.state + ' ' + business.zip
data['name'] = business.contact_first_name + ' ' + business.contact_last_name
data['business'] = business.business_name
data['city'] = business.city
data['state'] = business.state
data['location'] = data['city'] +', '+data['state']
data['zip'] = business.zip
data['category'] = business.category1

data['category'] = business.category1
data['company_details'] = business.business_description
data['keywords'] = business.keywords
data['year'] = business.year_founded.presence || "1980"
data['business_email'] = business.bings.first.email
data['business_hours'] = Getfave.consolidate_hours( business )
data['tagline'] = business.tag_line
data['user_type'] = 'new'
data['discription'] = business.business_description
data['url'] = business.company_website
data['bus_name_fixed'] = business.business_name.gsub(" ", "+")
data['city_fixed'] = business.city.gsub(" ", "+")
data
