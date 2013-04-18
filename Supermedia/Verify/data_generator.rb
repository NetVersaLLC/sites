data = {}
theurl,tempass			= Supermedia.check_email( business )
data[ 'url' ]			= theurl
data[ 'password' ]		= tempass
data[ 'username' ]		= business.bings.first.email
data[ 'permPass' ]		= Yahoo.make_password + "2"
data
