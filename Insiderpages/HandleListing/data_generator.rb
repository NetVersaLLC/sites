data = {}
catty                       = InsiderPage.where(:business_id => business.id).first
data[ 'business' ]		= business.business_name
data[ 'near_city' ]		= business.city + ', ' + business.state
data[ 'email' ]			= business.insider_pages.first.email
data[ 'password' ]		= business.insider_pages.first.password
data[ 'address' ]		= business.address + ' ' +business.address2
data[ 'city' ]			= business.city
data[ 'state' ]			= business.state
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'business_email' ]	= data[ 'email' ]
data[ 'website' ]		= business.company_website
data[ 'business_description' ]	= business.business_description
data[ 'services' ]		= ""#services
data[ 'message' ]		= ""#Message to customers
data[ 'categories' ]          = [catty.insider_page_category.name.gsub("\n", "")]
#data[ 'categories' ]		= [business.category1,business.category2,business.category3,business.category4,business.category5]
data[ 'tags' ]			= [business.category1,business.category2,business.category3,business.category4,business.category5]

data
