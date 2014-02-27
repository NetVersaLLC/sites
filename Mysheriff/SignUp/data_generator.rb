data = {
  "business_name" => business.business_name,
  "gender" => business.contact_gender,
  "first_name" => business.contact_first_name,
  "last_name" => business.contact_last_name,
  "email" => business.bings.first.email,
  "password" => Mysheriff.make_password,
  "birthday" =>  {
    "month" => Date::ABBR_MONTHNAMES[business.birthday.month],
    "day" => business.birthday.day.to_s,
    "year" => business.birthday.year.to_s
    },
  "address1" => business.address,
  "address2" => business.address2,
  "phone" => business.mobile_phone.split('-'),
  "city" => business.city,
  "zip" => business.zip,
  "category" => MysheriffCategory.find(business.mysheriffs.first.category_id).name,
  "website" => business.company_website,
  "state" => business.state
}
data

