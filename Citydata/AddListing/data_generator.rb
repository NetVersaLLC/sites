data = {}
catty = Citydata.where(:business_id => business.id).first
catty = CitydataCategory.find(catty.category_id)

data['business']	= business.business_name
data['address1']	= business.address
data['address2']	= business.address2
data['city']		= business.city
data['state']		= business.state_name
data['zip']			= business.zip
data['phone']		= business.local_phone
data['fax']			= business.fax_number
data['email']		= business.bings.first.email
data['hours']		= Getfave.consolidate_hours(business)
data['founded']		= business.year_founded
data['ccaccepted']	= if business.accepts_mastercard or business.accepts_visa or business.accepts_amex or business.accepts_discover then "Yes" else "No" end
#skipping this as we don't have the data
data['employees']	= 'skipped'
data['password']	= Yahoo.make_password
data['category']	= catty.name
data['description']	= business.business_description#business.status_message+" "+business.tag_line + " " + business.business_description + " \n " + data['hours'] + business.company_website.to_s
data