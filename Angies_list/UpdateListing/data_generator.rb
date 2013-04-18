data = {}
data[ 'email' ]             = business.bings.first.email 
data[ 'password' ]          = business.angies_lists.first.password
data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
data[ 'gender' ]            = business.contact_gender
data[ 'month' ]             = Date::MONTHNAMES[business.birthday.month]
data[ 'day' ]               = business.birthday.day
data[ 'year' ]              = business.birthday.year
data[ 'country' ]           = 'United States'
data[ 'language' ]          = 'English'
data[ 'phone' ]             = business.local_phone
data[ 'phone_area' ]        = business.local_phone.split("-")[0]
data[ 'phone_prefix' ]      = business.local_phone.split("-")[1]
data[ 'phone_suffix' ]      = business.local_phone.split("-")[2]
data[ 'company_name' ]      = business.business_name
data[ 'business_email' ]    = data[ 'email' ]
data[ 'address' ]  	    = business.address + ' ' + business.address2
data[ 'city' ]     	    = business.city
data[ 'state' ]    	    = business.state 
data[ 'zip' ]      	    = business.zip
data[ 'business_website' ]  = business.company_website
data[ 'business_phone' ]    = business.local_phone
data[ 'business_category' ] = business.category1
data[ 'fax_number' ]        = business.fax_number
data[ 'year_established' ]  = business.year_founded
data[ 'payment_methods' ]   = Yahoo.payment_methods(business)
data[ 'languages_served' ]  = 'English'
data[ 'description' ] 	    = business.business_description
data[ 'business_description' ] 	    = business.business_description
data['service_group'] = 'Consumer Services'


data[ 'service_not_offered' ] = ''
data[ 'service_offered' ] = business.category1 + ' ' + business.category2 + ' ' + business.category3 + ' ' + business.category4 + ' ' + business.category5
if business.accepts_checks
       	data['check'] = 'yes'
else 
	data['check'] = 'no' 
end
if business.accepts_visa 
	data['visa'] = 'yes'
else
       	data['visa'] = 'no'
end
if business.accepts_mastercard 
	data['mastercard'] = 'yes'
else 
	data['mastercard'] = 'no'
end
if business.accepts_amex
	data['american_express'] = 'yes'
else 
	data['american_express'] = 'no' 
end
if business.accepts_discover 
	data['discover'] = 'yes'
else 
	data['discover'] = 'no' 
end
if business.accepts_paypal 
	data['paypal'] = 'yes'
else 
	data['paypal'] = 'no' 
end
data['financing_available'] = 'no'#if business.accepts_financing data['financing_available'] = 'yes'; else data['financing_available'] = 'no' end
data['weekdays_opening_hours'] = business.monday_open
data['weekdays_closing_hours'] = business.monday_close
data['weekend_opening_hours'] = business.saturday_open
data['weekend_closing_hours'] = business.saturday_close
data['license_signature'] = 'My license application is in progress'
data
