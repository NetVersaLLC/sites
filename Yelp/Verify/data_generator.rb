data = {}
begin
	data[ 'link' ]  	= Yelp.check_email(business)
rescue Net::POPAuthenticationError
	data['link']		= :POPAuthenticationError
end
data
