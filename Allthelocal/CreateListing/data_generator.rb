data = {}
data['heap'] = business.allthelocals.first ? business.allthelocals.first.heap : "{}"
data['contact_name'] = business.contact_first_name + ' ' + business.contact_last_name
data['email'] = business.bings.first.email
data['local_phone'] = business.local_phone
data['business_name'] = business.business_name
data['address'] = business.address + ' ' + business.address2
data['city'] = business.city
data['state'] = business.state
data['zip'] = business.zip
data['company_website'] = business.company_website
data['keywords'] = business.keywords
data['business_description'] = business.business_description
data
