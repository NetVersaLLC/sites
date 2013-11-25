data = {}
catty = Bigwigbiz.where(:business_id => business.id).first
data['category'] = BigwigbizCategory.find(catty.category_id).name
data['address'] = business.address
data['business_description'] = business.business_description
data['business_name'] = business.business_name
data['city'] = business.city
data['local_phone'] = business.local_phone.gsub("-","")
data['contact_first_name'] = business.contact_first_name
data['contact_last_name'] = business.contact_last_name
data['email'] = business.bings.first.email
data['state'] = business.state_name
data['zip'] = business.zip
data['username'] = business.bings.first.email.split(//)[0..6].join + rand(1000).to_s
data['password'] = Yahoo.make_password
data['website'] = business.company_website
data
