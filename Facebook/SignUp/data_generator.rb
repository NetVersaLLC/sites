data = {}
data['first_name']				= business.contact_first_name
data['last_name']				= business.contact_last_name
data[ 'email' ] 				= business.bings.first.email
data[ 'password' ] 				= Yahoo.make_password
data['month'] 					= Date::MONTHNAMES[business.birthday.month][0..2]
data[ 'day' ] 					= business.birthday.day#business.contact_birthday.split("/")[1]
data[ 'year' ] 					= business.birthday.year#business.contact_birthday.split("/")[2]
data['gender']					= business.contact_gender
data['mobile']					= business.mobile_phone
data