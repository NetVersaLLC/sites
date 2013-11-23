data = {}
data['alternate_phone'] = business.alternate_phone
data['contact_first_name'] = business.contact_first_name
data['contact_gender'] = business.contact_gender
data['contact_last_name'] = business.contact_last_name
data['username'] = [business.business_name.split.join.downcase,Random.rand(10000..99999)].join
data['password'] = Yahoo.make_password
data['email'] = business.user.email
data['zip'] = business.zip
data['month'] = business.birthday.month
data['year'] = business.birthday.year
data['day'] = business.birthday.day
data['secret'] = "Emmie"
data
