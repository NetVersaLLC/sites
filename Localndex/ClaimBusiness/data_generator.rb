data = {}
data[ 'password' ]		= business.localndexes.first.password#Qw3Up-rkeRnIlQ
data[ 'email' ]			= business.localndexes.first.username
data[ 'name' ]			= business.contact_first_name + business.contact_last_name
data[ 'phone' ]			= business.local_phone
data[ 'phonetoll' ]		= business.toll_free_phone
data[ 'website' ]		= business.company_website
data[ 'hours' ]			= Localndex.get_hours(business)
data[ 'payments' ]		= Localndex.payment_methods(business)
data[ 'services' ]		= business.category1 + ' ' + business.category2 + ' ' + business.category3 + ' ' + business.category4 + ' ' + business.category5
data[ 'description' ]		= business.business_description
data
