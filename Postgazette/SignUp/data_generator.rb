data = {}
data['address'] = business.address
data['local_phone'] = business.local_phone.gsub("-","")
data['business_description'] = business.business_description
data['business_name'] = business.business_name
data['category'] = business.category1
data['city'] = business.city
data['state'] = business.state_name
data['company_website'] = business.company_website
data['contact_first_name'] = business.contact_first_name
data['contact_last_name'] = business.contact_last_name
data['email'] = business.bings.first.email
data['fax_number'] = business.fax_number.gsub("-","")
data['zip'] = business.zip
data['password'] = Yahoo.make_password
data
