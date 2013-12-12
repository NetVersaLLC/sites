seed = rand(10000).to_s
data = {}
data[ 'name' ]              = business.business_name.strip.gsub(/[^A-Za-z0-9_ ]/, '')
data[ 'country' ]           = 'United States'
data[ 'password' ]          = Bing.make_password
data[ 'mobile_phone' ]      = business.mobile_phone
data[ 'first_name' ]        = business.contact_first_name
data[ 'last_name' ]         = business.contact_last_name
begin
data[ 'birth_month' ]       = business.birthday.month
data[ 'birth_day' ]         = business.birthday.day
data[ 'birth_year' ]        = business.birthday.year
rescue ArgumentError
data[ 'birth_month' ]       = rand(10).to_s
data[ 'birth_day' ]         = rand(20).to_s
data[ 'birth_year' ]        = (1960 + rand(20)).to_s
end

data[ 'gender' ]            = business.contact_gender
data[ 'zip' ]               = business.zip
data[ 'alt_email' ]         = User.where(:id => business.user_id).first.email#Faker::Name.name.gsub(" ", "") + seed +"@gmail.com"
data
