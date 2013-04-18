data = {}
data[ 'country' ]		= "United States"
data[ 'state' ]			= business.state_name
data[ 'city' ]			= business.city
data[ 'email' ]			= business.bings.first.email
data[ 'password' ]		= Yahoo.make_password
data[ 'cityState' ]		= data['city'] + ", " + data['state']
data[ 'siteName' ]		= business.bings.first.email[0..14]
data[ 'state_name' ]		= business.state_name
data[ 'city' ]			= business.city
data[ 'business' ]		= business.business_name
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'fax' ]			= business.fax_number
data[ 'email' ]			= business.bings.first.email
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'fullname' ]		= data[ 'fname' ] + ' ' + data[ 'lname' ]
data

