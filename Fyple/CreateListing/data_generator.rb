data = {} 
data['email'] =    business.bings.first.email
data['password'] = business.fyples.first.password

data['business'] = business.business_name
data['city_state'] = business.city + ' ' + business.state

data['address1'] = business.address
data['address2'] = business.address2
data['country']  = 'United States' 
data['city']     = business.city
data['state']    = business.state
data['zip']      = business.zip
data['lphone']   = business.local_phone
data['mphone']   = business.mobile_phone
data['aphone']   = business.alternate_phone
data['url']      = business.company_website
data['desc']     = business.business_description
data['payments'] = Fyple.payments(business)
data
