data = {}
catty                       = Yellowise.where(:business_id => business.id).first
data[ 'password' ]		= business.yellowises.first.password #DgyggRoMBZU
data[ 'username' ]		= business.yellowises.first.username
data[ 'city' ]			= business.city
data[ 'statename' ]		= business.state_name
data[ 'zip' ]			= business.zip
data[ 'business' ]		= business.business_name
data[ 'yearfounded' ]		= business.year_founded
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zipcode3' ]		= ""
data[ 'phone' ]			= business.local_phone
data[ 'altphone' ]		= business.mobile_phone
data[ 'fax' ]			= business.fax_number
data[ 'tollfree' ]		= business.toll_free_phone
data[ 'website' ]		= business.company_website.gsub("http://", "")
data[ 'description' ]		= business.business_description
data[ 'category' ]          = catty.yellowise_category.parent.name.gsub("\n", "")
data[ 'keywords' ]		= business.category1 + "\n" + business.category2 + "\n" + business.category3 + "\n" + business.category4 + "\n" + business.category5
data
