# Maybe refactor to a single array of keys
@minimum_stay_nights = { 'LessThanThree' => 'minstay_1', 'MoreThanThree' => 'minstay_2' } # (not including holidays)
@security = { 'OnSite' => 'security_1', 'None' => 'security_2' }
@on_site_staff = { 'Yes' => 'onsitestaff_1', 'No' => 'onsitestaff_2' }
@room_cleaning = { 'IncludedInRate' => 'roomcleaning_1', 'AdditionalFee' => 'roomcleaning_2' }
@front_desk = { 'TwentyFourHours' => 'frontdesk_1', 'LimitedHours' => 'frontdesk_2',
  'None' => 'frontdesk_3' }
@bathroom = { 'AllEnSuite' => 'bathroom_1', 'SomeEnSuite' => 'bathroom_2',
  'Shared' => 'bathroom_3' }
@housekeeping = { 'Daily' => 'housekeeping_1', 'Weekly' => 'housekeeping_2',
  'BiWeekly' => 'housekeeping_3', 'None' => 'housekeeping_4' }

# See requirements for listings at at www.tripadvisor.com/pages/getlisted.html
# Use these to be listed in a particular accommodation category. it can be set via loop in
# the submit_new_hotel() function via @browser.radio( id )
hotel_requirements = @on_site_staff[ 'Yes' ], @front_desk[ 'TwentyFourHours' ], @housekeeping[ 'Daily' ],
  @room_cleaning[ 'IncludedInRate' ], @bathroom[ 'AllEnSuite' ], @minimum_stay_nights[ 'LessThanThree' ]
bnb_inns_requirements = @on_site_staff[ 'Yes' ], @housekeeping[ 'Daily' ],
  @room_cleaning[ 'IncludedInRate' ]
other_lodging = @on_site_staff[ 'Yes' ]
# Also for resources: We do not list reservation/booking sites or travel agencies. We also
# do not list anything temporary, like events or performances.

@resource_types = { 'OfficialInfo' => 3, 'Timeshare'=> 7, 'TourCompany' => 5, 'Miscellaneous' => 11 }

# Rules for submitting new or correcting a listings:
# - Hotel: photos, descriptions, minimum and maximum prices, number of rooms can be updated
#   once a year only.
# - Restaurant: submit a listing correction when the restaurant has closed or if the contact
#   info has changed. Other listing features can be updated once a year only.
# - Resource: photos and descriptions (both optional) must be submitted along with the new
#   resource listing request — you cannot add them later.
module ListingTypes
  HOTEL = 'Hotel'
  RESTAURANT = 'Restaurant'
  RESOURCE = 'Resource'
end

NEW_HOTEL_URL = 'http://www.tripadvisor.com/pages/getlisted_hotel_new.html'
NEW_RESTAURANT_URL = 'http://www.tripadvisor.com/pages/getlisted_restaurant_new.html'
NEW_RESOURCE_URL = 'http://www.tripadvisor.com/pages/getlisted_resource_new.html'
UPDATE_URL = 'http://www.tripadvisor.com/OwnerUpdateListing'


def submit_new_common( data, listing_type )

  @browser.text_field( :name, 'requester_name_req' ).set data[ 'personal_name' ]
  @browser.text_field( :name, 'requester_email_req' ).set data[ 'personal_email' ]
  if ListingTypes::RESOURCE == listing_type
    @browser.text_field( :name, 'url_req' ).set data[ 'personal_url' ]
  else
    @browser.text_field( :name, 'url' ).set data[ 'personal_url' ]
  end

  if ListingTypes::RESTAURANT == listing_type or ListingTypes::RESOURCE == listing_type
    @browser.text_field( :name, 'requester_connection_req' ).set data[ 'personal_connection' ]
    @browser.text_field( :name, 'telephone_number_req' ).set data[ 'business_phone' ]
  elsif ListingTypes::HOTEL == listing_type
    @browser.select_list( :name, 'requester_connection_req' ).select data[ 'personal_connection' ]
    @browser.text_field( :name, 'telephone_number' ).set data[ 'business_phone' ]
  else
    raise StandardError.new 'Failed to enter telephone number - unknown listing type'
  end

  @browser.text_field( :name, 'official_name_req' ).set data[ 'business_name' ]
  @browser.text_field( :name, 'street_req' ).set data[ 'business_address' ]
  @browser.text_field( :name, 'address_continued' ).set data[ 'business_address2' ]
  @browser.text_field( :name, 'city_req' ).set data[ 'business_city' ]
  @browser.text_field( :name, 'city_or_province_req' ).set data[ 'business_state' ]
  @browser.text_field( :name, 'postal_code_req' ).set data[ 'business_zip' ]
  @browser.text_field( :name, 'county_req' ).set data[ 'business_country' ]
  @browser.text_field( :name, 'fax_number' ).set data[ 'business_fax' ]
  @browser.text_field( :name, 'email_address_attraction' ).set data[ 'business_email' ]
  @browser.text_field( :name, 'description' ).set data[ 'description' ]

end

def submit_click

  @browser.checkbox( :name, 'you_are_official_req' ).set
  @browser.button( :name, 'submit' ).click

end


def submit_new_restaurant( data )

  puts 'Submit new restaurant'
  @browser.goto( NEW_RESTAURANT_URL )

  submit_new_common( data, ListingTypes::RESTAURANT )
  # .. select cuisine types
  @browser.select_list( :name, 'cuisine_types' ).clear
  data[ 'restaurant_cuisine_types' ].each{ |cuisine|
    @browser.select_list( :name, 'cuisine_types' ).select cuisine
  }

  submit_click()

end

def submit_new_hotel( data )

  puts 'Submit new hotel'
  @browser.goto( NEW_HOTEL_URL )

  submit_new_common( data, ListingTypes::HOTEL )
  @browser.text_field( :name, 'number_of_rooms_req' ).set data[ 'hotel_rooms_total' ]
  @browser.radio( :id, data[ 'minimum_stay_nights' ] ).set
  @browser.radio( :id, data[ 'security' ] ).set
  @browser.radio( :id, data[ 'on_site_staff' ] ).set # onsite required
  @browser.radio( :id, data[ 'room_cleaning' ] ).set
  @browser.radio( :id, data[ 'front_desk' ] ).set
  @browser.radio( :id, data[ 'bathroom' ] ).set
  @browser.radio( :id, data[ 'housekeeping' ] ).set

  submit_click()
  
end

def submit_new_resource( data )

  puts 'Submit new resource'
  @browser.goto( NEW_RESOURCE_URL )

  submit_new_common( data, ListingTypes::RESOURCE )
  @browser.select_list( :name, 'resource_type_req' ).select data[ 'resource_type' ]
  # TODO: Photos and descriptions (both optional) must be submitted along with the new
  # resource listing request—you cannot add them later.

  submit_click()

end


def update_existing( data, listing_type )
#This method updates and adds new listings
  puts 'Update existing listing: ' + data[ 'business_name' ]
  @browser.goto( UPDATE_URL )

  # Open business type page
  if ListingTypes::RESTAURANT == listing_type
    @browser.link( :text, 'Restaurants' ).click
  elsif ListingTypes::HOTEL == listing_type
    @browser.link( :text, 'Accommodations' ).click
  elsif ListingTypes::RESOURCE == listing_type
    # Note: there is a separate page for Tourism Organizations
    @browser.link( :text, 'Attractions' ).click
  end

  puts 'First search for existing business name in the city'
  search_text = data[ 'business_name' ] + ' ' + data[ 'business_city' ]
  @browser.text_field( :id, 'mainSearch' ).set search_text
  @browser.button( :id, 'mainSearchSubmit' ).click
    sleep(3)
  
  labelText = data[ 'business_name' ] + ', ' + data[ 'business_city' ] + ', ' + data[ 'business_state_name' ]
  if not @browser.label( :text, labelText).exists?

    puts 'No results found'

    # Submit new listing
    if ListingTypes::RESTAURANT == listing_type
      submit_new_restaurant( data )
    elsif ListingTypes::HOTEL == listing_type
      submit_new_hotel( data )
    end

  else

    puts 'Found the business to update'
    # Update existing listing (select first from the list)

    @browser.radio( :label => labelText).click

    # Consider submitting new business instead of registering one and signing up
    # .. Business Management Registration
    Watir::Wait::until do @browser.span( :text, 'Register my business' ).exists? end
    @browser.span( :text, 'Register my business' ).click

    sign_up(data)

  end

end

def find_business( data, listing_type )

  @browser.goto( 'http://www.tripadvisor.com/' )
if @browser.window(:title => "TripAdvisor").exists?	
  @browser.window(:title => "TripAdvisor").close
end
  # search for business name in city
  search_query = data[ 'business_name' ] + ' ' + data[ 'business_type' ] + ' ' + data[ 'business_city' ]
  @browser.text_field( :id, 'mainSearch' ).set search_query
  @browser.button( :id, 'mainSearchSubmit' ).click
  busLink = @browser.div( :id, 'SEARCH_RESULTS' ).link( :text, /#{data[ 'business_name' ]}/ )
  if busLink.exists?
	  busLink.click
	 # Handle found business
	  @browser.span( :text, 'Manage your listing' ).click
	  @browser.span( :text, 'Register now' ).click
if @browser.window(:title => "TripAdvisor").exists?	
  @browser.window(:title => "TripAdvisor").close
end
	  # Sign up for an account
	  sign_up( data )
  else
	update_existing( data, listing_type ) #this method is poorly named, it updates AND adds new listings. 
  end
 

end

def sign_up( data )
if @browser.window(:title => "TripAdvisor").exists?	
  @browser.window(:title => "TripAdvisor").close
end
  puts 'Sign up for an account'
  Watir::Wait::until do
    @browser.div( :id, 'signUpContainer' ).exists? or @browser.div(  :id, 'signInContainer' ).exists?
  end
  if @browser.span( :text, 'Join for free' ).exists? then
    @browser.span( :text, 'Join for free' ).click
  end
  Watir::Wait::until do
    @browser.form( :id, 'MemberSignIn' ).exists?
  end

  # Step 1
  @browser.text_field( :id, 'email' ).set data[ 'personal_email' ]
  @browser.text_field( :id, 'pass' ).set data[ 'personal_password' ]
  @browser.text_field( :id, 'firstname' ).set data[ 'personal_firstname' ]
  @browser.text_field( :id, 'lastname' ).set data[ 'personal_lastname' ]
  @browser.text_field( :id, 'location' ).set data[ 'business_city' ]
  @browser.checkbox( :id, 'keep' ).clear
  @browser.form( :id, 'MemberSignIn' ).submit

  # Step 2
  Watir::Wait::until do
    @browser.text.include? 'Step 2'
  end
  @browser.span( :class => 'centerBtn', :text => 'Continue' ).click
  #sleep 2
  #Watir::Wait::until do @browser.text.include? 'Link Your TripAdvisor Account' end
  Watir::Wait::until do
    @browser.text_field( :id, 'phone' ).exists?
  end
  @browser.select_list( :id, 'affil' ).select data[ 'personal_connection' ]
  @browser.text_field( :id, 'phone' ).set data[ 'business_phone' ]
  @browser.text_field( :id, 'propertyURL' ).set data[ 'business_url' ]

  @browser.checkbox( :id, 'reviewNotification' ).clear
  @browser.checkbox( :id, 'selfcertify' ).set
  @browser.checkbox( :id, 'termsofuse' ).set
  @browser.button( :class => 'centerBtn', :text => 'Continue' ).click

  # Step 3
  Watir::Wait::until do
    @browser.text.include? 'Step 3'
  end
  @browser.span( :text => 'Select' ).click

  puts 'TODO: Verify via Facebook left to complete'

end


def sign_in( data )

	@browser.goto( 'http://www.tripadvisor.com/Owners' )
	@browser.span( :class, 'taLnk hvrIE6').click

	@browser.text_field( :id, 'email' ).set data[ 'personal_email' ]
	@browser.text_field( :id, 'pass' ).set data[ 'personal_password' ]
	@browser.button( :value, 'Sign in').click
	@browser.window(:title => "TripAdvisor").close

end

find_business( data, data[ 'business_type' ] )
