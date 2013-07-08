data = {}

data[ 'businessname' ]      = business.business_name
data[ 'city' ]              = business.city
data[ 'state_short' ]       = business.state
data[ 'state_full' ]        = business.state_name
data[ 'addressfull' ]       = business.address + " " + business.address2
data[ 'address_uno' ]		= business.address
data[ 'address_dos' ]		= business.address2
data[ 'zip' ]               = business.zip
data[ 'phone' ]             = business.local_phone
data[ 'country' ]           = 'United States'
data[ 'hotmail' ]           = business.bings.first.email
data[ 'password' ]          = business.bings.first.password
data[ 'hours' ]			    = Getfav.consolidate_hours(business)
data[ 'brands' ]			= business.get_brands

bingy = Bing.where(:business_id => business.id).first
data[ 'category' ]          = bingy.bing_category.name

data[ 'mobile' ]			= business.mobile_phone
data[ 'toll_free_number' ]  = business.toll_free_phone
data[ 'fax_number' ]        = business.fax_number
data[ 'website' ]           = business.company_website
data[ 'facebook' ]          = '' # NOTE: unimlemented
data[ 'twitter' ]           = '' # NOTE: unimplemented
#data['logo'] = ContactJob.logo
#data['images'] = ContactJob.images

data[ 'year_established' ]  = business.year_founded
data[ 'description' ]       = business.business_description
data[ 'languages' ]         = [ 'English' ]
data[ 'payments' ]          = Bing.make_payments(business)
# data[ 'hours_monday_from' ] = '8:00'
# data[ 'hours_monday_to' ]   = '8:00'

data
