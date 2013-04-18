data = {}
data[ 'name' ]              = business.business_name.strip.gsub(/[^A-Za-z0-9_ ]/, '')
data[ 'country' ]           = 'United States'
data[ 'password' ]          = Bing.make_password
data[ 'secret_answer' ]     = Bing.make_secret_answer

data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
data[ 'birth_month' ]       = Date::MONTHNAMES[business.birthday.month]
data[ 'birth_day' ]         = business.birthday.day
data[ 'birth_year' ]        = business.birthday.year
data[ 'gender' ]            = business.contact_gender
data[ 'zip' ]               = business.zip
data[ 'alt_email' ]         = 'james.douglas@netversa.com'
data
