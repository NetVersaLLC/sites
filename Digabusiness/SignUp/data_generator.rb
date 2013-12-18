data = {}
data[ 'email' ]		    = business.bings.first.email
data[ 'username' ]		= data['email'].split('@').first
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'website' ]		= business.company_website
data[ 'password' ]		= Yahoo.make_password
data