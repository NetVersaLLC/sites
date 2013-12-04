data = {}
catty = Ycphonebook.where(:business_id => business.id).first
data['category'] = YcphonebookCategory.find(catty.category_id).name.chomp

data['address'] = business.address
data['local_phone'] = business.local_phone
data['business_name'] = business.business_name
data['city'] = business.city
data['state'] = business.state
data['company_website'] = business.company_website
data['contact_first_name'] = business.contact_first_name
data['contact_last_name'] = business.contact_last_name
data['email'] = business.bings.first.email
data['fax_number'] = business.fax_number
data['zip'] = business.zip
data
