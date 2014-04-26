phone = business.local_phone
fax = business.fax_number
data = {
  payload_framework: PayloadFramework._to_s,
  first_name: business.contact_first_name,
  last_name: business.contact_last_name,
  phone_area_code: phone[0..2],
  phone_prefix: phone[3..5],
  phone_suffix: phone[6..9],
  email: business.bings.first.email,
  company_name: business.business_name,
  address: business.address,
  address2: business.address2,
  city: business.city,
  state: business.state,
  category: business.category1,
  zip: business.zip,
  fax_area_code: fax[0..2],
  fax_prefix: fax[3..5],
  fax_suffix: fax[6..9],
  website: business.company_website
}