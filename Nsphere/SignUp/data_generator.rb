data = {}
data['business_name'] = business.business_name
data['category'] = NsphereCategory.find(business.nspheres.first.category_id).name
data['address'] = business.address
data['city'] = business.city
data['state'] = business.state_name
data['zip'] = business.zip
data['contact_first_name'] = business.contact_first_name
data['contact_last_name'] = business.contact_last_name
data['email'] = business.bings.first.email
data['phone'] = business.mobile_phone
data