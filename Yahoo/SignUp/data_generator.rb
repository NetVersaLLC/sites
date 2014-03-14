yahoo = business.yahoos.first
data = {}
data['heap']            = yahoo ? yahoo.heap : "{}" 
data['email']           = yahoo ? yahoo.email : ""
data['password']        = yahoo ? yahoo.password : ""

data['phone']           = business.local_phone.gsub('-','')
data['address']         = business.address + (((business.address2 || '') != '') ? ", #{business.address2}" : '')
data['city']            = business.city
data['state']           = business.state
data['zip']             = business.zip
data['firstname']       = business.contact_first_name
data['lastname']        = business.contact_last_name
data['username']        = business.contact_first_name+'_'+business.contact_last_name
data['new_password']        = SecureRandom.urlsafe_base64(rand()*6 + 6)+"aA#{rand(10)}"
data['mobile']          = business.mobile_phone

data['bday_month']      = business.birthday.strftime("%B") 
data['bday_day']        = business.birthday.day
data['bday_year']       = business.birthday.year
data['gender']          = business.contact_gender[0].downcase
data['verification_mobile']= business.mobile_phone
data['country_code']    = '1'
data['country']         = 'us'
data['verification_country_code']    = '1'
data['verification_country']         = 'us'
data
