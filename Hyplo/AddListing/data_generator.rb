data = {}
catty                       = Hyplo.where(:business_id => business.id).first
data[ 'email' ]			= business.hyplos.first.username
data[ 'password' ]		= business.hyplos.first.password
data[ 'website' ]		= business.company_website
data[ 'title' ]			= business.business_name
data[ 'description' ]		= business.business_description
data[ 'category' ] = catty.hyplo_category.name.gsub("\n", "").gsub("&amp;","&")
data[ 'zip' ]			= business.zip
data
