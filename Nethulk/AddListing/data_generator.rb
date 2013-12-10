data = {}
data['local_phone'] = business.local_phone
data['mobile_phone'] = business.mobile_phone
data['description'] = business.business_description
data['business'] = business.business_name
data['address'] = business.address
data['city'] = business.city
data['state'] = business.state
data['website'] = business.company_website
data['contact_name'] = "#{business.contact_first_name} #{business.contact_last_name}"
data['email'] = business.bings.first.email
data['fax'] = business.fax_number
data['zip'] = business.zip
data
