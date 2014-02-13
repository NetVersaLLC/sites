data = {}
fyple = business.fyples.first
data[ 'email' ]			   = business.bings.first.email
data[ 'bing_password'] = business.bings.first.password
data[ 'password' ]		 = fyple && fyple.password || Yahoo.make_password[0 .. 8]
data[ 'name'] = business.contact_first_name + ' ' + business.contact_last_name
data

