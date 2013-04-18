@payment_type_ids = { 'AmericanExpress' => 'Amex', 'CashOnly' => 'Cash',
  'DebitCard' => 'DebitCard', 'DinersClub' => 'DinersClub',
  'Discover' => 'Discover', 'Financing' => 'Financing',
  'GoogleCheckout' => 'GoogleCheckout', 'Invoice' => 'Invoice',
  'MasterCard' => 'MasterCard', 'OtherCard' => 'StoreCard',
  'Paypal' => '325480', 'PersonalChecks' => 'Check',
  'TravelersChecks' => 'TravelersCheck',  'Visa' => 'Visa' }

@other_information_ids = [ 'Reservations', 'BanquetMeetingRooms', 'FoodCourt',
  'LiveEntertainment', 'GiftShop', 'EquipmentRentals', 'LodgingCampgrounds', 'InternetAccess',
  'FreeInternet', 'ShuttleService', 'ParkPermitRequired', 'GreenCompanyIndicator',
  'LgbtFriendly', 'ValidationOptions' ]

def add_new_listing( data )

  puts 'Adding new listing: ' + data[ 'business_name' ]
  # assert signed in and confirmed, on My Account page
  #@browser.link( :text, 'Add New Listing' ).click
@browser.goto( 'http://listings.expressupdateusa.com/Dashboard/Edit' )

  @browser.text_field( :id, 'Listing_CompanyName' ).set data[ 'business_name' ]
  @browser.text_field( :id, 'Listing_LocationAddress' ).set data[ 'business_address' ]
  @browser.text_field( :id, 'Listing_LocationSuite' ).set data[ 'business_suite' ]
  @browser.text_field( :id, 'Listing_LocationCity' ).set data[ 'business_city' ]
  @browser.select_list( :id, 'LocationStateId' ).select data[ 'business_state' ]
  @browser.text_field( :id, 'Listing_LocationZipCode' ).set data[ 'business_zip' ]
  @browser.text_field( :id, 'Listing_LocationPhone' ).set data[ 'business_phone' ]

  @browser.text_field( :id, 'Enhanced_Fax' ).set data[ 'business_fax' ]
  @browser.text_field( :id, 'Enhanced_TollFree' ).set data[ 'business_tollfree' ]
  @browser.text_field( :id, 'Enhanced_WebAddress' ).set data[ 'business_url' ]

  @browser.checkbox( :id, 'Enhanced_PresenceOfECommerce' ).set if data[ 'business_ecommerce' ]

  # select first category from the list
  @browser.text_field( :id, 'CategorySearch' ).set data[ 'business_category' ]
  @browser.link( :id, 'categorySearch' ).click
  sleep(10)
  @browser.div( :class, 'categoryItem' ).click
=begin
  def first_found_category; @browser.div( :class, 'categoryItem' ) end
  Watir::Wait::until do first_found_category.exists? end
  first_found_category.click
=end
  @browser.text_field( :id, 'Enhanced_Products' ).set data[ 'business_products' ]
  @browser.text_field( :id, 'Enhanced_Services' ).set data[ 'business_services' ]
  @browser.text_field( :id, 'Enhanced_Keywords' ).set data[ 'business_keywords' ]
  @browser.text_field( :id, 'Enhanced_EmployeeSize' ).set data[ 'business_employeesize' ]
  @browser.text_field( :id, 'Enhanced_LogoLink' ).set data[ 'business_logourl' ]
  @browser.text_field( :id, 'Enhanced_LongLocalWebAddress' ).set data[ 'business_alternateurl' ]
  @browser.text_field( :id, 'Enhanced_CouponLink' ).set data[ 'business_couponurl' ]
  @browser.text_field( :id, 'Enhanced_TwitterLink' ).set data[ 'business_twitterurl' ]
  @browser.text_field( :id, 'Enhanced_FaceBookLink' ).set data[ 'business_facebookurl' ]
  @browser.text_field( :id, 'Enhanced_YouTubeVideoLink' ).set data[ 'business_youtubeurl' ]
  @browser.text_field( :id, 'Enhanced_LinkedInLink' ).set data[ 'business_linkedinurl' ]

  @browser.select_list( :id, 'Enhanced_MondayOpen' ).select clean_time(data[ 'business_mondayopen' ])
  @browser.select_list( :id, 'Enhanced_MondayClose' ).select clean_time(data[ 'business_mondayclose' ])

  @browser.select_list( :id, 'Enhanced_TuesdayOpen' ).select clean_time(data[ 'business_mondayopen' ])
  @browser.select_list( :id, 'Enhanced_TuesdayClose' ).select clean_time(data[ 'business_mondayclose' ])

  @browser.select_list( :id, 'Enhanced_WednesdayOpen' ).select clean_time(data[ 'business_mondayopen' ])
  @browser.select_list( :id, 'Enhanced_WednesdayClose' ).select clean_time(data[ 'business_mondayclose' ])

  @browser.select_list( :id, 'Enhanced_ThursdayOpen' ).select clean_time(data[ 'business_mondayopen' ])
  @browser.select_list( :id, 'Enhanced_ThursdayClose' ).select clean_time(data[ 'business_mondayclose' ])

  @browser.select_list( :id, 'Enhanced_FridayOpen' ).select clean_time(data[ 'business_mondayopen' ])
  @browser.select_list( :id, 'Enhanced_FridayClose' ).select clean_time(data[ 'business_mondayclose' ])

  @browser.select_list( :id, 'Enhanced_SaturdayOpen' ).select clean_time(data[ 'business_mondayopen' ])
  @browser.select_list( :id, 'Enhanced_SaturdayClose' ).select clean_time(data[ 'business_mondayclose' ])

  @browser.select_list( :id, 'Enhanced_SundayOpen' ).select clean_time(data[ 'business_mondayopen' ])
  @browser.select_list( :id, 'Enhanced_SundayClose' ).select clean_time(data[ 'business_mondayclose' ])

=begin
  data[ 'payment_types' ].each { |item|
  puts(@payment_type_ids[ item ])
  puts(item)
  next if @payment_type_ids[ item ].to_s == ""
  next if @payment_type_ids[ item ].to_s == "nil"
    @browser.checkbox( :id, 'Enhanced_' + @payment_type_ids[ item ] ).set
    puts("payments")
  }
=end
  @browser.text_field( :id, 'Contact_FirstName' ).set data[ 'personal_firstname' ]
  @browser.text_field( :id, 'Contact_LastName' ).set data[ 'personal_lastname' ]
  @browser.select_list( :id, 'ContactTitle' ).select data[ 'personal_title' ]
  @browser.text_field( :id, 'Contact_ContactEmail' ).set data[ 'personal_email' ]
  @browser.text_field( :id, 'Enhanced_MobileNumber' ).set data[ 'personal_phone' ]
  
=begin
  data[ 'other_information' ].each { |item|
    @browser.checkbox( :id, 'Enhanced_' + item.to_s ).set
  }
=end
  @browser.button( :id, 'SubmitListingButton' ).click
  true

end

sign_in( data )
add_new_listing( data )
true
