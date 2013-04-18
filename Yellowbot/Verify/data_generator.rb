data = {}
data[ 'email' ] 		= business.yellow_bots.first.email
data[ 'username' ] 		= data[ 'email' ]
data[ 'password' ] 		= business.yellow_bots.first.password
data['url']   = YellowBot.check_email(business)
data