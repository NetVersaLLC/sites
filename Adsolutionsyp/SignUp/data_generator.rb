data = {}
seed = rand(10000).to_s

catty = Adsolutionsyp.where(:business_id => business.id).first
data['category']			= catty.adsolutionsyp_category.name

data['phone']				= business.local_phone.gsub("-","")
data['business']			= business.business_name
data['fname']				= business.contact_first_name
data['lname']				= business.contact_last_name
data['email']				= business.bings.first.email
data['address']				= business.address + " " + business.address2
data['city']				= business.city
data['state']				= business.state
data['zip']					= business.zip
data['founded']				= business.year_founded
data['category']			= "Food Delivery Service"
data['payments']			= Adsolutionsyp.payment_methods(business)
data['password']			= Yahoo.make_password
data['secret_answer']		= Yahoo.make_secret_answer1
data['website']				= business.company_website
data