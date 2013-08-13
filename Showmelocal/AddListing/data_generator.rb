data = {}
seed 							= rand(1000).to_s
catty                       	= Showmelocal.where(:business_id => business.id).first
data[ 'business' ]				= business.business_name
data[ 'category' ]          	= catty.showmelocal_category.name
data[ 'type' ]					= business.category1
data[ 'address' ]				= business.address
data[ 'address2' ]				= business.address2
data[ 'address_full' ]			= business.address + ", " + business.address2
data[ 'country' ]				= "United States"
data[ 'state' ]					= business.state_name
data[ 'city' ]					= business.city
data[ 'zip' ]					= business.zip
data[ 'phone' ]					= business.local_phone
data[ 'description' ]			= business.business_description
data[ 'email' ]					= business.bings.first.email
data['fname']					= business.contact_first_name
data['lname']					= business.contact_last_name
data['password']				= business.showmelocals.first.password
days 							= ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
days.each do |day|
data["#{day}"]					= business.send("#{day}_enabled".to_sym)
data["#{day}_open"]				= business.send("#{day}_open".to_sym)
data["#{day}_close"]			= business.send("#{day}_close".to_sym)
end 
data