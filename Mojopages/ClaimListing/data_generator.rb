phone = business.local_phone.gsub('-','')
data = {
  payload_framework: PayloadFramework._to_s,
  first_name: business.contact_first_name,
  last_name: business.contact_last_name,
  email: (business.mojopages.first.email or business.bings.first.email),
  password: (business.mojopages.first.password or Mojopages.make_password),
  zip: business.zip,
  gender: business.contact_gender.downcase,
  category: MojopagesCategory.find(business.mojopages.first.category_id).name,
  phone_area_code: phone[0..2],
  phone_prefix: phone[3..5],
  phone_suffix: phone[6..9]
}