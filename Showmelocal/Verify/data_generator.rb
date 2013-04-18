data = {}
data[ 'url' ]		= Showmelocal.check_email(business).gsub("%252","%2").gsub("%253","%3")
data[ 'password' ]	= business.showmelocals.first.password
data
