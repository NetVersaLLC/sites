data = {}
data[ 'email' ]			= business.merchantcircles.first.email
data[ 'password' ]			= business.merchantcircles.first.password
data[ 'phone_area' ] 		= business.local_phone.split("-")[0]
data[ 'phone_prefix' ] 		= business.local_phone.split("-")[1]
data[ 'phone_suffix' ] 		= business.local_phone.split("-")[2]
data[ 'phone' ] 			= data[ 'phone_area'] + data[ 'phone_prefix'] + data[ 'phone_suffix']
data[ 'name' ]				= business.business_name
data[ 'address' ] 			= business.address + ' ' + business.address2
data[ 'city' ] 				= business.city
data[ 'state' ] 			= business.state_name
data[ 'zip' ] 				= business.zip
data[ 'first_name' ]		= business.contact_first_name
data[ 'last_name' ] 		= business.contact_last_name
data[ 'website' ]			= business.company_website
data[ 'short_description' ] = business.business_description
data[ 'payment_methods' ] 	= Merchantcircle.payment_methods(business)
data[ 'description' ]		= business.business_description
data[ 'monOpen' ]			= business.monday_open
data[ 'monClose' ]			= business.monday_close
data[ 'tuesOpen' ]			= business.tuesday_open
data[ 'tuesClose' ]			= business.tuesday_close
data[ 'wedOpen' ]			= business.wednesday_open
data[ 'wedClose' ]			= business.wednesday_close
data[ 'thurOpen' ]			= business.thursday_open
data[ 'thurClose' ]			= business.thursday_close
data[ 'fridOpen' ]			= business.friday_open
data[ 'fridClose' ]			= business.friday_close
data[ 'satOpen' ]			= business.saturday_open
data[ 'satClose' ]			= business.saturday_close
data[ 'sunOpen' ]			= business.sunday_open
data[ 'sunClose' ]			= business.sunday_close
data[ 'keywords' ]			= business.category1 + ", " + business.category2 + ", " + business.category3 + ", " + business.category4 + ", " + business.category5 
catty                   = Merchantcircle.where(:business_id => business.id).first

if catty.merchantcircle_category.parent.parent.name
	thecats = {
		'levelone' => catty.merchantcircle_category.parent.parent.name,
		'leveltwo' => catty.merchantcircle_category.parent.name,
		'levelthree' => catty.merchantcircle_category.name 
	};
else
	thecats = { 
		'levelone' => catty.merchantcircle_category.parent.name,
		'leveltwo' => catty.merchantcircle_category.name 
		};
end

data['thecategories'] = thecats

data
