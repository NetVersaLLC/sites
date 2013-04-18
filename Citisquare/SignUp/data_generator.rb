data = {}
catty                       = Citisquare.where(:business_id => business.id).first

data[ 'email' ] = business.bings.first.email
data[ 'password' ] = Yahoo.make_password
data[ 'phone_area' ] = business.local_phone.split("-")[0]
data[ 'phone_prefix' ] = business.local_phone.split("-")[1]
data[ 'phone_suffix' ] = business.local_phone.split("-")[2]
data[ 'business' ] = business.business_name
data[ 'state' ] = business.state_name
data[ 'zip' ] = business.zip
data[ 'description' ] = business.business_description
data[ 'first_name' ] = business.contact_first_name
data[ 'last_name' ] = business.contact_last_name
data[ 'address' ] = business.address + ' ' +business.address2
data[ 'city' ] = business.city
data[ 'category' ]          = catty.citisquare_category.parent.name.gsub("\n", "")
data[ 'sub_category' ] = catty.citisquare_category.name.gsub("\n", "")

data[ 'specials' ] = business.category1 + ' ' +business.category2 + ' ' +business.category3 + ' ' +business.category4 + ' ' +business.category5
data
