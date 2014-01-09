data = {}

catty            = Yahoo.where(:business_id => business.id).first
data['category'] = YahooCategory.find(catty.category_id).name

['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'].each do |day|
  enabled= business.send("#{day}_enabled".to_sym)
  open=    business.send("#{day}_open".to_sym)
  close=   business.send("#{day}_close".to_sym)
  if enabled
    data["#{day[0..2]}_open"]=  open.starts_with?('0') ? open.downcase[1..-1] : open.downcase
    data["#{day[0..2]}_close"]= close.starts_with?('0') ? close.downcase[1..-1] : close.downcase
  else
    data["#{day[0..2]}_open"]=  'Closed'
    data["#{day[0..2]}_close"]= 'Closed'
  end
end

payment = []
payment << 'CASHONLY'   if business.accepts_cash
payment << 'CHECK'      if business.accepts_checks
payment << 'MASTERCARD' if business.accepts_mastercard
payment << 'VISA'       if business.accepts_visa
payment << 'DISCOVER'   if business.accepts_discover
payment << 'DINERS'     if business.accepts_diners
payment << 'AMEX'       if business.accepts_amex
payment << 'PAYPAL'     if business.accepts_paypal
payment << 'BITCOIN'    if business.accepts_bitcoin

data['business_name']   = business.business_name
data['phone']           = business.local_phone.gsub('-','')
data['address']         = business.address + (((business.address2 || '') != '') ? ", #{business.address2}" : '')
data['city']            = business.city
data['state']           = business.state
data['zip']             = business.zip
data['firstname']       = business.contact_first_name
data['lastname']        = business.contact_last_name
data['username']        = business.contact_first_name+'_'+business.contact_last_name
data['password']        = SecureRandom.urlsafe_base64(rand()*6 + 6)+"aA#{rand(10)}"
data['mobile']          = business.mobile_phone

data['birthday']        = business.contact_birthday
data['gender']          = business.contact_gender[0].downcase
data['bizemail']        = business.bings.first.email
data['bizurl']          = business.company_website
data['yearestablished'] = business.year_founded
data['addlphone']       = business.alternate_phone
data['toll_free_phone'] = business.toll_free_phone
data['fax']             = business.fax_number
data['payment']         = payment
data['products']        = business.business_description
data['verification_mobile']= business.mobile_phone
data['country_code']    = '1'
data['country']         = 'us'
data['verification_country_code']    = '1'
data['verification_country']         = 'us'
credentials= Yahoo.where(:business_id=> 644).first
data['yahoo_username']         = credentials.email
data['yahoo_password']         = credentials.password
data
