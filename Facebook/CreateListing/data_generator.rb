data = {}
data[ 'website' ]	= business.company_website
data[ 'category' ]	= business.category1
data['logo'] = ContactJob.logo
data[ 'business_description' ] = business.business_description
data['email']= business.facebooks.first.email
data['password']  = business.facebooks.first.password
data
