data = {}
data[ 'email' ]					= business.bings.first.email
data[ 'password' ]				= business.showmelocals.first.password
data[ 'desc' ]					= business.business_description
catty                   		= Showmelocal.where(:business_id => business.id).first
data[ 'name' ]					= business.business_name
data[ 'category' ]  			= catty.showmelocal_category.name
data[ 'type' ]					= business.category1
data[ 'address' ]				= business.address
data[ 'address2' ]				= business.address2
data[ 'address_full' ]			= business.address + ", " + business.address2
data[ 'country' ]				= "United States"
data[ 'state' ]					= business.state
data[ 'city' ]					= business.city
data[ 'zip' ]					= business.zip
data[ 'phone' ]					= business.local_phone
data[ 'fax' ]					= business.fax_number
data[ 'website' ]				= business.company_website
data[ 'keywords' ]				= business.category1 + ", " +business.category2 + ", " +business.category3 + ", " +business.category4 + ", " +business.category5
data[ 'payments' ]				= Showmelocal.payment_methods(business)
data[ 'tollfree' ]				= business.toll_free_phone
days 							= ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
days.each do |day|
data["#{day}"]					= business.send("#{day}_enabled".to_sym)
data["#{day}_open"]				= business.send("#{day}_open".to_sym)
data["#{day}_close"]			= business.send("#{day}_close".to_sym)
end
data