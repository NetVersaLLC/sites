iform = business.iformatives.first
data = {
  "heap"  => iform.heap,
  "username" => business.bings.first.email.split("@").first + "9",
  "new_email" => business.bings.first.email,
  "new_password" => Yahoo.make_password,
  "business_name" => business.business_name,
  "email" => iform.email,
  "password" => iform.password,
  "address" => business.address,
  "phone" => business.mobile_phone,
  "city" => business.city,
  "state" => business.state_name,
  "zip" => business.zip,
  "category" => IformativeCategory.find(iform.category_id).name,
  "website" => business.company_website,
  "bing_password" => business.bings.first.password
}
