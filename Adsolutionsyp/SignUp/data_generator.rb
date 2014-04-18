record = business.adsolutionsyps.first
category = AdsolutionsypCategory.find(record.category_id).name
corporate_name = business.corporate_name
corporate_name = "" if corporate_name.length > 30
password = record.password
password = Yahoo.make_password if password.nil?
data = {
  payload_framework: PayloadFramework._to_s,
  phone: business.local_phone.gsub("-",""),
  company_name: business.business_name,
  contact_first_name: business.contact_first_name,
  contact_last_name: business.contact_last_name,
  email: business.bings.first.email,
  category: category,
  address: [business.address,business.address2].join(" "),
  city: business.city,
  state: business.state,
  zip: business.zip,
  year_founded: business.year_founded,
  payment_methods: PayloadHelper.payment_methods(business),
  password: password,
  secret_answer: Yahoo.make_secret_answer1,
  website: business.company_website,
  mobile_phone: business.mobile_phone,
  alternate_business_name: corporate_name
}.merge PayloadHelper.get_hours(business)