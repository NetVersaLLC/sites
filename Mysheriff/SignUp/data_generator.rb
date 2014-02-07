data = {}
data['gender'] =     business.contact_gender
data['first_name'] = business.contact_first_name
data['last_name'] =  business.contact_last_name
data['email'] =      business.bings.first.email
data['password'] =   Yahoo.make_password
data['city'] =       business.city
# Birthday variables
data['birthday_month'] = business.birthday.month
data['birthday_day'] =   business.birthday.day
data['birthday_year'] =  business.birthday.year
data