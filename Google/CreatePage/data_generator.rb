if business.category1 == nil
  raise "Not Categorized"
end

data = {}
data[ 'email' ]           = "mrenkin5594@gmail.com"#business.googles.first.email
data[ 'pass' ]            = "razzabrazza45"#business.googles.first.password
data[ 'business' ]        = business.business_name
data[ 'zip' ]             = "80249".to_i#business.zip.to_i
data[ 'name' ]            = business.contact_first_name + " " + business.contact_last_name
data[ 'phone' ]           = "7209431856"#business.local_phone
data[ 'state' ]           = "Colorado"#business.state_name
data[ 'address' ]         = "4465 Andes Ct."#business.address
data[ 'hours'   ]         = Google.get_hours(business)
data[ 'city' ]		= "Denver"#@business.city
data[ 'website'] 	= business.company_website
data[ 'description'] = business.business_description
#catty = Facebook.where(:business_id => business.id).first
data['category']	= business.category1
data['country'] = 'United States'
data[ 'fax' ] = business.fax_number
data[ 'mobile?' ] = business.mobile_appears
data[ 'mobile' ] = business.mobile_phone
data
