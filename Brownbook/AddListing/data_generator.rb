data = {}
data['business'] 	 = business.business_name
data['address'] 	 = business.address
data['address2'] 	 = business.address2
data['zip'] 		 = business.zip
data['local_phone']  = business.local_phone
data['mobile_phone'] = business.mobile_phone
data['fax'] 		 = business.fax_number
data['email'] 		 = business.brownbooks.first.email
data['website'] 	 = business.company_website
data['tags']  		 = business.tag_line
data['state'] 		 = business.state
data['city'] 		 = business.city
data['password']	 = business.brownbooks.first.password
data['name']		 = business.contact_first_name + ' ' + business.contact_last_name
data