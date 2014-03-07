data = {
  "heap" => business.mysheriffs.first.heap, 

  "new_email" => business.bings.first.email,
  "new_password" => Mysheriff.make_password,

  "images_synced" => business.completed_jobs.where(:name => 'Utils/ImageSync').first.present?,
  "business_name" => business.business_name,
  "gender" => business.contact_gender,
  "first_name" => business.contact_first_name,
  "last_name" => business.contact_last_name,
  "email" => business.mysheriffs.first.email,
  "password" => business.mysheriffs.first.password,
  "birthday" =>  {
    "month" => Date::ABBR_MONTHNAMES[business.birthday.month],
    "day" => "%02d" % business.birthday.day,
    "year" => business.birthday.year.to_s
    },
  "address1" => business.address,
  "address2" => business.address2,
  "phone" => business.mobile_phone.split('-'),
  "city" => business.city,
  "zip" => business.zip,
  "category" => MysheriffCategory.find(business.mysheriffs.first.category_id).name,
  "website" => business.company_website,
  "state" => business.state,
  "description" => business.business_description,
  "hours" => Mysheriff.get_hours(business),
  "payment_methods" => Mysheriff.payment_methods(business)
}
data
