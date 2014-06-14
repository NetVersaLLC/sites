data = {}
data[ 'email' ]	= business.freebusinessdirectories.first.email
data[ 'password' ]	= business.freebusinessdirectories.first.password
data[ 'userid' ] = business.bings.first.email[0 .. 15].gsub("@","")
data[ 'bing_password']  = business.bings.first.password
data
