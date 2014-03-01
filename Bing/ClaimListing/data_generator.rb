data = {}
data[ 'business' ]      = business.business_name
data[ 'city' ]          = business.city
data[ 'state_name' ]    = business.state_name
data[ 'state_short' ]   = business.state
data[ 'address' ]       = business.address
data[ 'address2' ]      = business.address2
data[ 'zip' ]           = business.zip
data[ 'phone' ]         = business.local_phone
data[ 'hotmail' ]       = business.bings.first.email
data[ 'password' ]      = business.bings.first.password
data[ 'secret_answer' ] = business.bings.first.secret_answer
data[ 'local_phone' ]   = business.local_phone
data[ 'website' ]       = business.company_website
catty                   = Bing.where(:business_id => business.id).first
data[ 'category' ]      = BingCategory.find(catty.category_id).name.chop
data
