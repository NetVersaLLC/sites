data = {}
seed = rand(10000).to_s()
data['first_name'] = business.contact_first_name
data['last_name'] = business.contact_last_name
data['nickname'] =  data['last_name'] + data['first_name'] + seed
data['location'] = business.city
data['language'] = 'en'
data['email'] = business.bings.first.email #.split("@")[0] + seed + "@" + business.bings.first.email.split("@")[1]
data['website'] = business.company_website
data['website_name'] = business.business_name
data['biography'] = business.business_description
data
