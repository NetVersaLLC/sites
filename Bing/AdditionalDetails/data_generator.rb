data = {}
data[ 'hotmail' ]      	= business.bings.first.email
data[ 'password' ]     	= business.bings.first.password
data[ 'hours' ]			= Getfav.consolidate_hours(business)
data[ 'founded' ]		= business.year_founded
data[ 'mobile' ]		= business.mobile_phone
data[ 'mobile_appears' ] = business.mobile_appears
data[ 'tollfree' ]		= business.toll_free_phone
data[ 'mobile' ]		= business.fax_number
data[ 'payments' ]		= Bing.make_payments(business)
data[ 'description' ]	= business.business_description
data
