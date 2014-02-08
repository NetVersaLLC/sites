data = {}
catty = Ibegin.where(:business_id => business.id).first
data[ 'email' ]			= business.ibegins.first.email
data[ 'password' ]		= business.ibegins.first.password
data[ 'business_name' ]	= business.business_name
data[ 'country' ]		= "United States"
data[ 'state_name' ]	= business.state_name
data[ 'city' ]			= business.city
data[ 'address' ]		= business.address + ' ' + business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'fax' ]			= business.fax_number
data[ 'category' ] 	= IbeginCategory.find(catty.category_id).name.chomp
data[ 'url' ]			= business.company_website
data[ 'facebook' ]		= ""#business.facebooks.first.facebook_url
data[ 'twitter_name' ]	= ""#business.twitters.first.twitter_url
data[ 'desc' ]			= business.business_description[0 .. 245]
data[ 'brands' ]		= business.get_brands
data[ 'products' ]		= ""#business.get_products
data[ 'services' ]		= business.services_offered
data[ 'payment_methods' ]	= Ibegin.payment_methods( business )
data

