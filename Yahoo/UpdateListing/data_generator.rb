data = {}
data['email']   	 = business.yahoos.first.email
data['password']	 = business.yahoos.first.password
data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
data[ 'gender' ]            = business.contact_gender
data[ 'month' ]             = Date::MONTHNAMES[business.birthday.month]
data[ 'day' ]               = business.birthday.day
data[ 'year' ]              = business.birthday.year
data[ 'country' ]           = 'United States'
data[ 'language' ]          = 'English'
data[ 'phone' ]             = business.local_phone
data[ 'business_name' ]     = business.business_name
data[ 'business_email' ]    = '' # business.contact_email
data[ 'business_address' ]  = business.address + ' ' + business.address2
data[ 'business_city' ]     = business.city
data[ 'business_state' ]    = business.state_name
data[ 'business_zip' ]      = business.zip
data[ 'business_website' ]  = business.company_website
data[ 'business_phone' ]    = business.local_phone
catty = Yahoo.where(:business_id => business.id).first
data[ 'business_category' ] = catty.yahoo_category.subcatname
data[ 'fax_number' ]        = business.fax_number
data[ 'year_established' ]  = business.year_founded
data[ 'payment_methods' ]   = Yahoo.payment_methods(business)
data[ 'languages_served' ]  = 'English'
data['hours']				= Yahoo.get_hours(business)
data
