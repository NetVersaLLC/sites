kudzu = business.kudzus.first
salutation = (business.contact_gender == "Male" and "Mr.") or "Ms."
phone = business.local_phone.gsub('-','')
fax = business.fax_number.gsub('-','')
data = {
  payload_framework: PayloadFramework._to_s,
  username: kudzu.username,
  password: kudzu.password,
  industry: KudzuCategory.find(kudzu.category_id).parent,
  category: KudzuCategory.find(kudzu.category_id),
  salutation: salutation,
  first_name: business.contact_first_name,
  last_name: business.contact_last_name,
  company_name: business.business_name,
  website: business.company_website,
  address: business.address,
  address2: business.address2,
  city: business.city,
  state: business.state,
  zip: business.zip,
  phone_area_code: phone[0..2],
  phone_prefix: phone[3..5],
  phone_suffix: phone[6..9],
  fax_area_code: fax[0..2],
  fax_prefix: fax[3..5],
  fax_suffix: fax[6..9],
  payment_methods: PayloadHelper.payment_methods(business),
  languages_spoken: [:english],
  year_founded: business.year_founded
}.merge PayloadHelper.get_hours(business)