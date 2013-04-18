data = {}
catty                 = Yippie.where(:business_id => business.id).first
data[ 'category1' ] = catty.yippie_category.name.gsub("\r\r", "").gsub("\n", "")
data[ 'state_name' ]		= business.state_name
data[ 'state' ]			= business.state
data[ 'city' ]			= business.city
data[ 'business' ]		= business.business_name
data[ 'addressComb' ]		= business.address + "  " + business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'areacode' ]		= business.local_phone.split("-")[0]
data[ 'exchange' ]		= business.local_phone.split("-")[1]
data[ 'last4' ]			= business.local_phone.split("-")[2]
data[ 'fax' ]			= business.fax_number
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website
data[ 'description' ]		= business.business_description
data





