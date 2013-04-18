data = {}
monthNumber = business.contact_birthday.split("/")[0].to_i
data[ 'phone' ] = business.local_phone
data[ 'first_name' ] = business.contact_first_name 
data[ 'last_name' ] = business.contact_last_name
data[ 'password' ] = business.bings.first.password
data[ 'company_name' ] = business.business_name
data[ 'username' ] = business.business_name.gsub(/\s+/, "") # removing the prohibited whitespaces
data[ 'zip' ] = business.zip
data[ 'day' ] = business.contact_birthday.split("/")[1]
data[ 'month' ] = Date::MONTHNAMES[monthNumber]
data[ 'year' ] = business.contact_birthday.split("/")[2]
data[ 'gender' ] = business.contact_gender.downcase
data[ 'security_question' ] = 'In which city did your parents meet?'
data[ 'Security_answer' ] = 'Newyork'
data
