data = {}
catty                   = Localcensus.where(:business_id=>business.id).first
data[ 'category' ]      = LocalcensusCategory.find(catty.category_id).name
data[ 'state' ]			= business.state_name
data[ 'city' ]			= business.city
data[ 'business' ]		= business.business_name
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'fax' ]			= business.fax_number
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website
data[ 'hours' ]			= Getfave.consolidate_hours( business )
data[ 'description' ]		= business.business_description
data
