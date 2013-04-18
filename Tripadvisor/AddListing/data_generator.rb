data = {}
data[ 'personal_firstname' ] 		= business.contact_first_name
data[ 'personal_lastname' ] 		= business.contact_last_name
data[ 'personal_name' ] 		= data[ 'personal_firstname' ] + ' ' + data[ 'personal_lastname' ]
data[ 'personal_connection' ]  		= 'Owner'
data[ 'personal_email' ]  		= business.bings.first.email
data[ 'personal_password' ]  		= business.bings.first.password
data[ 'personal_url' ] 			= business.company_website

data[ 'business_type' ]			= 'Restaurant'#must be Hotel, Restaurant, or Resource
data[ 'business_name' ] 		= business.business_name
data[ 'business_city' ] 		= business.city
data[ 'business_address' ] 		= business.address
data[ 'business_address2' ] 		= business.address2
data[ 'business_email' ] 		= business.bings.first.email
data[ 'business_url' ] 			= data[ 'personal_url' ]
data[ 'business_state' ] 		= business.state
data[ 'business_state_name' ] 		= business.state_name
data[ 'business_zip' ] 			= business.zip
data[ 'business_country' ] 		= 'United States'
data[ 'business_phone' ] 		= business.local_phone
data[ 'business_fax' ] 			= business.fax_number
data[ 'description' ] 			= business.business_description

# Refactor to the same as @resource_types. Up to 4 items.
data[ 'restaurant_cuisine_types' ] 	= [ 'American', 'Asian', 'Pizza' ]

# Additional hotel details
data[ 'hotel_rooms_total' ] 		= '12'
data[ 'minimum_stay_nights' ] 		= @minimum_stay_nights[ :LessThanThree ]
data[ 'security' ] 			= @security[ :OnSite ]
data[ 'on_site_staff' ] 		= @on_site_staff[ :Yes ]
data[ 'room_cleaning' ] 		= @room_cleaning[ :IncludedInRate ]
data[ 'front_desk' ] 			= @front_desk[ :TwentyFourHours ]
data[ 'bathroom' ] 			= @bathroom[ :AllEnSuite ]
data[ 'housekeeping' ] 			= @housekeeping[ :Daily ]
data[ 'resource_type' ] 		= @resource_types[ :Timeshare ]
data
