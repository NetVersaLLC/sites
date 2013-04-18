data = {}
data[ 'url' ]			= Craigslist.confirm_post_url( business )
data[ 'prefix' ]		= business.local_phone.split("-")[0]
data[ 'suffix' ]		= business.local_phone.split("-")[1]
data[ 'last4' ]			= business.local_phone.split("-")[2]
data
