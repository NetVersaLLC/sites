data = {}

catty = Yellowassistance.where(:business_id => business.id).first
data[ 'category1' ]          = catty.yellowassistance_category.name.gsub("\n", "")
data[ 'category2' ]          = catty.yellowassistance_category.name.gsub("\n", "")
data['email']		= business.bings.first.email
data['password']	= business.yellowassistances.first.password
data[ 'username' ]		= business.bings.first.email[0..14]
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'fullname' ]		= data[ 'fname' ] + ' ' + data[ 'lname' ]
data[ 'title' ]			= "Owner"
data[ 'category3' ]		= business.category3
data[ 'state_name' ]		= business.state_name
data[ 'state' ]			= business.state
data[ 'city' ]			= business.city
data[ 'business' ]		= business.business_name
data[ 'addressComb' ]		= business.address + "  " + business.address2
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'areacode' ]		= business.local_phone.split("-")[0]
data[ 'exchange' ]		= business.local_phone.split("-")[1]
data[ 'last4' ]			= business.local_phone.split("-")[2]
data[ 'fax' ]			= business.fax_number
data[ 'website' ]		= business.company_website
data[ 'description' ]		= business.business_description
data[ 'tagline' ]		= business.category1 + " " + business.category2 + " " + business.category3
data[ 'image' ]			= "C:\\1.jpg"
data[ 'country' ]		= "United States"
data[ 'suburb' ]		= "None"
data[ 'tollfree' ]		= business.toll_free_phone
data[ 'hours' ]			= Localndex.get_hours(business)
data[ 'payments' ]		= Yellowassistance.payment_methods(business)
data




