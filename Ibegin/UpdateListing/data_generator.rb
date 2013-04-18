data = {}
catty = Ibegin.where(:business_id => business.id).first
data[ 'email' ]			= business.ibegins.first.email
data[ 'password' ]		= business.ibegins.first.password
data[ 'business_name' ]		= business.business_name
data[ 'country' ]		= "United States"
data[ 'state_name' ]		= business.state_name
data[ 'city' ]			= business.city
data[ 'address' ]		= business.address + ' ' + business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'fax' ]			= business.fax_number
data[ 'category1' ] = catty.ibegin_category.name.gsub("\n", "")
data[ 'url' ]			= business.company_website
data[ 'facebook' ]		= ""#business.facebooks.first.email
data[ 'twitter_name' ]		= ""#business.twitters.first.username
data[ 'desc' ]			= business.business_description[0 .. 245]
data[ 'brands' ]		= ""#
data[ 'products' ]		= ""#
data[ 'services' ]		= business.category1 + ', ' +business.category2 + ', ' +business.category3 + ', ' +business.category4 + ', ' +business.category5
data[ 'payment_methods' ]	= Ibegin.payment_methods( business )
data