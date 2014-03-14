mycity = business.mycitybusinesses.first
data = {
  :heap  => mycity ? mycity.heap: "{}", 
  :email => business.bings.first.email,
  :bing_password => business.bings.first.password,
  :state => business.state_name,
  :city  => business.city,
  :business => business.business_name
}
data
