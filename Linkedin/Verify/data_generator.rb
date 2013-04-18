data = {}
data['url']		 = Linkedin.check_email(business)
data['email']		 = business.linkedins.first.email
data['password']	 = business.linkedins.first.password
data
