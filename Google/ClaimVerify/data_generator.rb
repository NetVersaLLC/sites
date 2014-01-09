data = {}
data[ 'email' ]    = business.googles.first.email
data[ 'pass' ]     = business.googles.first.password
data[ 'link' ]     = business.googles.first.listing_url
data[ 'business' ] = "Public Chicago"#business.business_name
data[ 'name' ]     = business.contact_first_name + " " + business.contact_last_name
data