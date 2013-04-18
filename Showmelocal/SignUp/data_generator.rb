data = {}
seed = rand(1000).to_s
catty                       = Showmelocal.where(:business_id => business.id).first
data[ 'business' ]		= business.business_name
data[ 'category' ]          = catty.showmelocal_category.name
data[ 'type' ]		= business.category1
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'country' ]		= "United States"
data[ 'state' ]		= business.state_name
data[ 'city' ]		= business.city
data[ 'zip' ]			= business.zip
data[ 'phone' ]		= business.local_phone
data[ 'fax' ]			= business.fax_number
data[ 'email' ]		= business.bings.first.email
data[ 'website' ]		= business.company_website
data[ 'description' ]	= business.business_description
data[ 'keywords' ]		= business.category1 + ", " +business.category2 + ", " +business.category3 + ", " +business.category4 + ", " +business.category5
data[ 'fname' ]		= business.contact_first_name
data[ 'lname' ]		= business.contact_last_name
data[ 'password' ]		= Yahoo.make_password
data

