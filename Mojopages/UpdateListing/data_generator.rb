phone = business.local_phone
category = MojopagesCategory.find(business.mojopages.first.category_id).name
data = {
  payload_framework: PayloadFramework._to_s,
  company_name: business.business_name,
  first_name: business.contact_first_name,
  last_name: business.contact_last_name,
  email: (business.mojopages.first.email or business.bings.first.email),
  address: [business.address, business.address2].join(' '),
  city: [business.city, business.state].join(', '),
  zip: business.zip,
  phone: phone,
  phone_area_code: phone[0..2],
  phone_prefix: phone[3..5],
  phone_suffix: phone[6..9],
  website: business.company_website,
  password: (business.mojopages.first.password or Mojopages.make_password),
  gender: business.contact_gender.downcase,
  tagline: business.tag_line,
  description: business.business_description,
  category: category.downcase
}