data = {}
catty = Citydata.where(:business_id => business.id).first

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
if business.accepts_mastercard or business.accepts_visa or business.accepts_amex or business.accepts_discover
	data['ccaccepted']	= "Yes"
else 
	data['ccaccepted']	= "No"
end
data['employees']	= 'skipped'
data['password']	= Yahoo.make_password
data['category']	= CitydataCategory.find(catty.category_id).name
data['description']	= business.business_description
data
