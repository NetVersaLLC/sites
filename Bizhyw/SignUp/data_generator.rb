data = {}

catty = BizhywCategory.find( business.bizhyws.first.category_id )
parent = catty.parent

data['business_name'] = business.business_name
data['category'] = parent.name
data['state_long'] = business.state_name
data['subcategory'] = catty.name
data['address'] = business.address
data['city'] = business.city
data['zip'] = business.zip
data['company_website'] = business.company_website
data['email'] = business.bings.first.email
data['phone1'] = business.local_phone.split("-")[0]
data['phone2'] = business.local_phone.split("-")[1]
data['phone3'] = business.local_phone.split("-")[2]
data['password'] = Yahoo.make_password
data['email'] = business.user.email
data
