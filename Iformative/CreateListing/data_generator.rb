data = {
  "business_name" => business.business_name,
  "email" => business.iformatives.first.email,
  "password" => business.iformatives.first.password,
  "address" => business.address,
  "phone" => business.mobile_phone,
  "city" => business.city,
  "state" => business.state_name,
  "zip" => business.zip,
  "category" => IformativeCategory.find(business.iformatives.first.category_id).name,
  "website" => business.company_website
}