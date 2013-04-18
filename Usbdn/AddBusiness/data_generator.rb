data = {}
data[ 'category1' ]		= business.category1
data[ 'business' ]		= business.business_name
data[ 'fakeurl' ]		= business.bings.first.email.split("@")[0]
data[ 'state' ]			= business.state_name
data[ 'city' ]			= business.city
data[ 'phone' ]			= business.local_phone
data[ 'altphone' ]		= business.alternate_phone
data[ 'fax' ]			= business.fax_number
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website
data[ 'description' ]		= business.business_description
data[ 'password' ]		= Yahoo.make_password #JlSZQVMlAn96DA
data[ 'address' ] 		= business.address + " " + business.address2
data[ 'zip' ]			= business.zip
data
