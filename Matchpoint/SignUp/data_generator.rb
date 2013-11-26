data = {}
catty                   = Matchpoint.find_by_business_id(business.id)
data[ 'category1' ]     = MatchpointCategory.find(catty.category_id).name.gsub("\n", "")
data[ 'username' ]		= business.bings.first.email[0..14]
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'fullname' ]		= [data[ 'fname' ],data[ 'lname' ]].join ' '
data[ 'state_name' ]		= business.state_name
data[ 'state' ]			= business.state
data[ 'city' ]			= business.city
data[ 'business' ]		= business.business_name
data[ 'addressComb' ]		= [business.address,business.address2].join ' '
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'areacode' ]		= business.local_phone.split("-")[0]
data[ 'exchange' ]		= business.local_phone.split("-")[1]
data[ 'last4' ]			= business.local_phone.split("-")[2]
data[ 'fax' ]			= business.fax_number
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website
data[ 'description' ]		= business.business_description
data[ 'categorys' ]		= [business.category1,business.category2,business.category3,business.category4,business.category5].join ', '
data[ 'tagline' ]		= [business.category1,business.category2,business.category3].join ' '
data[ 'country' ]		= "United States"
data[ 'suburb' ]		= "None"
data[ 'tollfree' ]		= business.toll_free_phone
data[ 'title' ]			= "Owner"
data[ 'password' ]		= Yahoo.make_password
data




