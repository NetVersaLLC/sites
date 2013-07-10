data = {}
catty                    		   		= Yellowtalk.where(:business_id => business.id).first
data['category'] = 						catty.yellowtalk_category.name
data[ 'city' ] = 						business.city
data[ 'name' ] = 						business.business_name