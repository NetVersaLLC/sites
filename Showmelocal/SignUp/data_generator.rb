catty = business.showmelocals.first.category_id
data = {}
data[:payload_framework]  = PayloadFramework._to_s
data[:company_name]       = business.business_name
data[:email]              = business.bings.first.email
data[:first_name]         = business.contact_first_name
data[:last_name]          = business.contact_last_name
data[:password]           = Yahoo.make_password
data[:category]           = ShowmelocalCategory.find(catty)
data[:phone]              = business.alternate_phone
data[:address]            = business.address
data[:zip]                = business.zip
data