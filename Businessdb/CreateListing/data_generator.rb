data = {}
seed = rand(2000).to_s

catty = Businessdb.where(:business_id => business.id).first

data['email'] = business.businessdbs.first.email
data['password'] = business.businessdbs.first.password
data['first_name'] = business.contact_first_name
data['last_name'] = business.contact_last_name
data['full_name'] = data['first_name'] + ' ' + data['last_name']
data['address'] = business.address + ' ' + business.address2
data['city'] = business.city
data['state'] = business.state
data['zip'] = business.zip
data['business'] = business.business_name
data['businessfixed'] = data['business']
data['business_category'] = catty.businessdb_category.parent.name
data['business_category2'] = catty.businessdb_category.name
data['location'] = data['business'] + ', ' + data['city']
data['country'] = 'United States of America'
data['website'] = business.company_website
data['business_description'] = business.business_description
data['phone'] = business.local_phone
data['fax'] = business.fax_number #this is required for some retarded reason. 
if data['fax'] == ""
  data['fax'] = "111-111-1111"
end

data