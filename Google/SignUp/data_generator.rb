data = {}
data['fname'] = business.contact_first_name
data['lname'] = business.contact_last_name
data['useragent'] = UserAgent.get
data['recover_email'] = business.bings.first.email
