data = {}
data['email']			= business.showmelocals.first.username
data['password']		= business.showmelocals.first.password
data['desc']			= business.business_description
data['hours']			= Showmelocal.get_hours( business )
catty                   = Showmelocal.where(:business_id => business.id).first
data[ 'name' ]			= business.business_name
data[ 'category1' ]  	= catty.showmelocal_category.name
data[ 'type' ]			= business.category1
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'country' ]		= "United States"
data[ 'state_name' ]	= business.state_name
data[ 'city' ]			= business.city
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'fax' ]			= business.fax_number
data[ 'website' ]		= business.company_website
data[ 'keywords' ]		= business.category1 + ", " +business.category2 + ", " +business.category3 + ", " +business.category4 + ", " +business.category5
data[ 'fname' ]			= business.contact_first_name
data[ 'lname' ]			= business.contact_last_name
data[ 'payments' ]		= Showmelocal.payment_methods(business)
data[ 'tollfree' ]		= business.toll_free_phone
data