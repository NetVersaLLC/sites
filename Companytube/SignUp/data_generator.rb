data = {}
data['contact_first_name'] = business.contact_first_name
data['contact_last_name'] = business.contact_last_name
data['email'] = "testuser51382@netversa.com"#business.bings.first.email
data['password'] = Yahoo.make_password
data['zip'] = business.zip
data['month'] = business.birthday.strftime("%B")[0..2]
data['day'] = business.birthday.day
data['year'] = business.birthday.year
data['username'] = [data['email'].split('@')[0][0..13],Random.rand(1000..9999)].join
data
