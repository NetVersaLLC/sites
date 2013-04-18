data = {}
data['username']		= business.cornerstonesworlds.first.username
data['password']		= business.cornerstonesworlds.first.password
data['email']			= business.bings.first.email

catty                   = Cornerstonesworld.where(:business_id => business.id).first
data[ 'business' ]		= business.business_name
data[ 'category' ]  	= catty.cornerstonesworld_category.name.gsub("\n", "")
data[ 'address' ]		= business.address + ' ' + business.address2
data[ 'city' ]			= business.city
data[ 'zip' ] 			= business.zip
data[ 'country' ]		= "USA"
data[ 'state' ]			= business.state_name
data[ 'phone' ]			= business.local_phone
data[ 'phone2' ]		= business.alternate_phone
data[ 'fax' ]			= business.fax_number
if business.mobile_appears == true
	data[ 'mobilephone' ]	= business.mobile_phone
else
	data[ 'mobilephone' ]	= ""
end
data[ 'website' ]		= business.company_website
data[ 'email' ]			= business.bings.first.email
data[ 'name' ]			= business.contact_first_name
data[ 'namelast' ]		= business.contact_last_name
data[ 'gender' ]		= business.contact_gender
data