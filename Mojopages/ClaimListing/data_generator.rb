data = {}
 seed = rand( 1000 ).to_s()
data[ 'phone_area' ] = business.local_phone.split("-")[0]
data[ 'phone_prefix' ] = business.local_phone.split("-")[1]
data[ 'phone_suffix' ] = business.local_phone.split("-")[2]
data[ 'phone' ] = business.local_phone
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'email' ] = business.bings.first.email
data[ 'f_email' ] =  business.mojopages.first.email #seed  + 
data[ 'f_password' ] = business.mojopages.first.password
data[ 'business' ] = business.business_name
data[ 'streetnumber' ] = business.address + ' ' + business.address2
data[ 'city' ] = business.city
data[ 'state' ] = business.state_name
data[ 'stateabreviation' ] = business.state
data[ 'zip' ] = business.zip
data[ 'country' ] = 'United States'
data[ 'citystate' ] = data[ 'city' ] + ', ' + data[ 'stateabreviation' ]
data[ 'url' ] = business.company_website
data[ 'tagline' ] = business.category1 + ' ' + business.category2 + ' ' + business.category3 + ' ' + business.category4 + ' ' + business.category5
data[ 'description' ] = business.business_description
data[ 'password' ] = Mojopages.make_password
data[ 'category' ] = business.category1
data[ 'gender' ] = "Male"#business.contact_gender
data

