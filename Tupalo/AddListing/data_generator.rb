data = {}
catty 							= Tupalo.where(:business_id => business.id).first
data['category1'] 				= TupaloCategory.find(catty.tupalo_category.parent_id).name
data['category2'] 				= catty.tupalo_category.name
data['email']     				= business.tupalos.first.email
data['password']  				= business.tupalos.first.password
data['business']  				= business.business_name
data['address']   				= business.address + " " + business.address2
data['city']      				= business.city
data['citystatecountry'] 		= business.city + ", " + business.state + ", " + "United States"
data['citystate']		 		= business.city + ", " + business.state
data['website']   				= business.company_website
data['phone']     				= business.local_phone
days 							= ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']

days.each do |day|
data["#{day}"]					= business.send("#{day}_enabled".to_sym)
data["#{day}_open"]				= business.send("#{day}_open".to_sym)
data["#{day}_close"]			= business.send("#{day}_close".to_sym)
end 

data
