data = {}
data[ 'firstname' ]		= business.contact_first_name
data[ 'lastname' ]		= business.contact_last_name
data[ 'business' ]		= business.business_name
data[ 'email' ]			= business.bings.first.email
data[ 'website' ]		= business.company_website[0..-2]
data[ 'keywords' ]		= [business.category1,business.category2,business.category3].join ' '
data[ 'address' ]		= business.address + ' ' + business.address2
data[ 'city' ]			= business.city
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone.gsub("-"," ")
data[ 'cellphone' ]		= business.mobile_phone.gsub("-"," ")
data[ 'fax' ]			= business.fax_number.gsub("-"," ")
data[ 'prefix' ]		= business.contact_prefix
data[ 'statename' ]		= business.state_name
data[ 'logopath' ]		= "C:\\1.jpg"#business.logo_file_name
data
