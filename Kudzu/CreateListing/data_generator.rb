data = {}
catty                       = Kudzu.where(:business_id => business.id).first
data[ 'userName']			= business.kudzus.first.username
data[ 'pass']				= business.kudzus.first.password
data[ 'industry' ]          = catty.kudzu_category.parent.name.gsub("\n", "")
data[ 'category' ]       	= catty.kudzu_category.name.gsub("\n", "")
data[ 'prefix' ]			= business.contact_prefix
data[ 'firstName' ]			= business.contact_first_name
data[ 'lastName' ]			= business.contact_last_name
data[ 'businessName' ]		= business.business_name
data[ 'website' ]			= business.company_website
data[ 'busAddress1' ]		= business.address
data[ 'busAddress2' ]		= business.address2
data[ 'busCity' ]			= business.city
data[ 'busState' ]			= business.state
data[ 'busZip1' ]			= business.zip
data[ 'busNPA' ]			= business.local_phone.split("-")[0]
data[ 'busNXX' ]			= business.local_phone.split("-")[1]
data[ 'busPlusFour' ]		= business.local_phone.split("-")[2]
data[ 'busExtension' ]		= ''#TODO
data[ 'fax' ]				= business.fax_number
data