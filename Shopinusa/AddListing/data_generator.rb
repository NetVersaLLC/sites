data = {}
shopinusa = Shopinusa.where(business_id: business.id).first
category = ShopinusaCategory.find(shopinusa.category_id)
firstname = business.contact_first_name
lastname = business.contact_last_name
data[:payload_framework] = PayloadFramework._to_s
data[:company_title] = business.business_name
data[:address] = business.address
data[:city] = business.city
data[:state] = business.state_name
data[:zip] = business.zip
data[:phone] = business.local_phone
data[:contact_name] = [firstname,lastname].join ' '
data[:email] = business.bings.first.email
data[:description] = business.business_description
data[:payment_methods] = Shopinusa.payment_methods(business)
data.merge! Shopinusa.get_hours(business)
data[:categories] = [
  category.parent.name, 
  "Adult Books & Movies", 
  business.category3
]
puts data
puts data[:payload_framework]
data