data = {}
data[ 'state' ]			= business.state
data[ 'city' ]			= business.city
data[ 'business' ]		= business.business_name
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'areacode' ]		= business.local_phone.split("-")[0]
data[ 'exchange' ]		= business.local_phone.split("-")[1]
data[ 'last4' ]			= business.local_phone.split("-")[2]
data[ 'fax' ]			= business.fax_number
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website.gsub("http://", "")
data[ 'description' ]		= business.business_description
data[ 'keywords' ]		= business.category1 + ", " + business.category2 + ", " + business.category3 + ", " + business.category4 + ", " + business.category5
data[ 'tagline' ]		= business.category1 + " " + business.category2 + " " + business.category3
data[ 'county' ]		= ""
data[ 'fullname' ]		= business.contact_first_name + " " + business.contact_last_name

data




