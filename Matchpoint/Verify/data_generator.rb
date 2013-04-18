data = {}
#data[ 'url' ]			= Matchpoint.check_email(business)
data[ 'email' ]			= business.bings.first.email
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'fullname' ]		= data[ 'fname' ] + ' ' + data[ 'lname' ]
data[ 'password' ]		= Yahoo.make_password
data
