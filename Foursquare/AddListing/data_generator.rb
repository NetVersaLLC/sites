data = {}
data['email']         = business.foursquares.first.email
data['password']      = business.foursquares.first.password
data['phone_area']    = business.local_phone.split("-")[0]
data['phone_prefix']  = business.local_phone.split("-")[1]
data['phone_suffix']  = business.local_phone.split("-")[2]
data['phone']         = data['phone_area'] + data['phone_prefix'] + data['phone_suffix']
data['first_name']    = business.contact_first_name
data['last_name']     = business.contact_last_name
data['city']          = business.city
data['state']         = business.state #need abreviation
data['citystate']     = data['city'] + ', ' + data['state']
data['zip']           = business.zip
data['address']       = business.address + ' ' + business.address2
data['business']      = business.business_name
data['associated_as'] = 'Owner'
data['birth_month']   = business.contact_birthday.split("/")[0]
data['birth_day']     = business.contact_birthday.split("/")[1]
data['birth_year']    = business.contact_birthday.split("/")[2]
data['twitter_page']  = business.twitters.first.nil? ? '' : business.twitters.first.twitter_page

catty = Foursquare.where(:business_id => business.id).first
data['category']      = catty.foursquare_category.name
data['category_top']  = catty.foursquare_category.parent.name

data