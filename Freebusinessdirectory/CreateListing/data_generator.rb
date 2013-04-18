data = {}
data[ 'username' ]		= business.freebusinessdirectories.first.username
data[ 'password' ]		= business.freebusinessdirectories.first.password#203T_RFVBA
data[ 'description' ]		= business.business_description
data[ 'website' ]		= business.company_website
data[ 'salutation' ]		= business.contact_prefix
data[ 'middlename' ]		= business.contact_middle_name
data[ 'position' ]		= "Owner"
data[ 'areacode' ]		= business.local_phone.split("-")[0] 
data[ 'phone' ]			= business.local_phone.split("-")[1] + business.local_phone.split("-")[2]
data[ 'city' ]			= business.city
data[ 'state' ]			= business.state_name
data[ 'zip' ]			= business.zip
data[ 'location_name' ]		= business.business_name
data[ 'contact_description' ]	= "Owner"
data[ 'nameFNL' ]		= business.contact_first_name + ' ' + business.contact_last_name
data[ 'linkdescription' ]	= "Homepage"
data
