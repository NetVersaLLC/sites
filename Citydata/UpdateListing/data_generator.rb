data = {}
data['email']		= business.citydata.first.email
data['pass']		= business.citydata.first.password
data['business']	= business.business_name
data['address1']	= business.address
data['address2']	= business.address2
data['city']		= business.city
data['state']		= business.state_name
data['zip']			= business.zip
data['phone']		= business.local_phone
data['fax']			= business.fax_number
data['hours']		= Getfave.consolidate_hours(business)
data['founded']		= business.year_founded
data['ccaccepted']	= if business.accepts_mastercard or business.accepts_visa or business.accepts_amex or business.accepts_discover then "Yes" else "No" end
#skipping this as we don't have the data
data['employees']	= 'skipped'
data['category']	= CitydataCategory.find(business.citydata.first.category_id).name
data['description']	=  "#{business.business_description}  \n #{business.status_message} #{business.tag_line} #{business.services_offered} #{data['hours']} #{business.company_website}"
data
