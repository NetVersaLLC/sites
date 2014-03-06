cd = business.citydata.first

data = {}
data['heap']    = cd.heap
data['email']		= cd.email
data['pass']		= cd.password
data['new_email']     = business.bings.first.email
data['new_password']	= Yahoo.make_password
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
data['employees']	= 'skipped'
data['category']	= CitydataCategory.find(cd.category_id).name
data['description']	=  "#{business.business_description}  \n #{business.status_message} #{business.tag_line} #{business.services_offered} #{data['hours']} #{business.company_website}"

if business.accepts_mastercard or business.accepts_visa or business.accepts_amex or business.accepts_discover
	data['ccaccepted']	= "Yes"
else 
	data['ccaccepted']	= "No"
end
data
