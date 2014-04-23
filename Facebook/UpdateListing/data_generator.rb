data = {}
data[ 'email' ] 				= business.facebooks.first.email
data[ 'password']				= business.facebooks.first.password
data[ 'page_password' ] 		= Yahoo.make_password
data[ 'business' ] 				= business.business_name + rand(1000).to_s
data[ 'zip' ] 					= business.zip
data[ 'phone' ] 				= business.local_phone
data[ 'address' ] 				= business.address
data[ 'city' ]					= business.city
data[ 'state' ]  				= business.state_name
data['location']				= data['city']+', '+data['state']
data[ 'website'] 				= business.company_website
data[ 'business_description' ] 	= business.business_description
catty 							= Facebook.where(:business_id => business.id).first
data['profile_category']		= FacebookProfileCategory.find(catty.category_id).name
data['category']				= FacebookCategory.find(catty.category_id).name
monthname = Date::MONTHNAMES[business.birthday.month]
data[ 'birth_month' ] 			= monthname[0..2]
data[ 'birth_day' ] 			= business.birthday.day
data[ 'birth_year' ] 			= business.birthday.year
data[ 'year_founded']           = business.year_founded
data[ 'waddress' ]              = business.business_name[0..12].gsub(" ","-").gsub(/[^0-9a-z -_]/i, '').downcase

# Messy but easy to use hours of operation variables
data[ '24hours' ] = business.open_24_hours
data[ 'mon_enab' ] = business.monday_enabled
data[ 'tue_enab' ] = business.tuesday_enabled
data[ 'wed_enab' ] = business.wednesday_enabled
data[ 'thu_enab' ] = business.thursday_enabled
data[ 'fri_enab' ] = business.friday_enabled
data[ 'sat_enab' ] = business.saturday_enabled
data[ 'sun_enab' ] = business.sunday_enabled

data[ 'mon_open' ] = business.monday_open.gsub("AM"," am").gsub("PM"," pm")
data[ 'tue_open' ] = business.tuesday_open.gsub("AM"," am").gsub("PM"," pm")
data[ 'wed_open' ] = business.wednesday_open.gsub("AM"," am").gsub("PM"," pm")
data[ 'thu_open' ] = business.thursday_open.gsub("AM"," am").gsub("PM"," pm")
data[ 'fri_open' ] = business.friday_open.gsub("AM"," am").gsub("PM"," pm")
data[ 'sat_open' ] = business.saturday_open.gsub("AM"," am").gsub("PM"," pm")
data[ 'sun_open' ] = business.sunday_open.gsub("AM"," am").gsub("PM"," pm")

data[ 'mon_close' ] = business.monday_close.gsub("AM"," am").gsub("PM"," pm")
data[ 'tue_close' ] = business.tuesday_close.gsub("AM"," am").gsub("PM"," pm")
data[ 'wed_close' ] = business.wednesday_close.gsub("AM"," am").gsub("PM"," pm")
data[ 'thu_close' ] = business.thursday_close.gsub("AM"," am").gsub("PM"," pm")
data[ 'fri_close' ] = business.friday_close.gsub("AM"," am").gsub("PM"," pm")
data[ 'sat_close' ] = business.saturday_close.gsub("AM"," am").gsub("PM"," pm")
data[ 'sun_close' ] = business.sunday_close.gsub("AM"," am").gsub("PM"," pm")

data
