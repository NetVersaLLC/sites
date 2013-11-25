data = {}
catty  			 			 = Nationalwebdir.where(:business_id => business.id).first
data['category'] 			 = NationalwebdirCategory.find(catty.category_id).name
data['business_description'] = business.business_description
data['business_name'] 		 = business.business_name
data['city'] 				 = business.city
data['company_website']		 = business.company_website
data['email'] 				 = business.bings.first.email
data['state'] 				 = business.state_name
data
