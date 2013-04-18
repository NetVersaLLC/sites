data = {}
data[ 'url' ]		= Freebusinessdirectory.check_email( business )
data[ 'username' ]	= business.freebusinessdirectories.first.username
data[ 'password' ]	= business.freebusinessdirectories.first.password

data
