def enter_business_portal_details( business )
puts("before the wait in enter_business_portal_details")
  
    sleep(5)
	#Watir::Wait::until { @browser.div( :text, 'YOUR BUSINESS INFORMATION' ).exists? }
  
  puts("after the wait in enter_business_portal_details")

  # .. Select business category
  @browser.div( :class, 'LiveUI_Area_Category' ).input().click
  # Can't find the way to click on a first search result, so click on 1st category without searching
  # @browser.div( :class, 'LiveUI_Area_Browse_and_Search' ).text_field().set business[ 'category' ]
  # @browser.send_keys :enter
  #Watir::Wait::until do
   # @browser.div( :class, /Hierarchy_Item/ ).exists?
   puts("Sleeping until all the Divs and Javascript Load")
   sleep(10)
  #end
  @browser.div( :title, /#{business[ 'category' ]}/i ).click #fire_event( 'onMouseDown' )
  @browser.div( :title => 'Close').click

  @browser.div( :class, 'LiveUI_Area_Business_address_line_1' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_Business_address_city' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_Business_address_state' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_Business_address_zip_code' ).text_field().click
  
  @browser.div( :class, 'LiveUI_Area_Toll_free_number' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_Fax_number' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_Email_Address' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_URL' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_Facebook_URL' ).text_field().click
  @browser.div( :class, 'LiveUI_Area_Twitter_URL' ).text_field().click
  
  @browser.div( :class, 'LiveUI_Area_Toll_free_number' ).text_field().set business[ 'toll_free_number' ]
  @browser.div( :class, 'LiveUI_Area_Fax_number' ).text_field().set business[ 'fax_number' ]
  @browser.div( :class, 'LiveUI_Area_Email_Address' ).text_field().set business[ 'email' ]
  @browser.div( :class, 'LiveUI_Area_URL' ).text_field().set business[ 'website' ]
  @browser.div( :class, 'LiveUI_Area_Facebook_URL' ).text_field().set business[ 'facebook' ]
  @browser.div( :class, 'LiveUI_Area_Twitter_URL' ).text_field().set business[ 'twitter' ]

  @browser.div( :text, 'Next' ).click
  @browser.div( :text, 'Next' ).click # it is not redirected from 1st click, so click twice
end

def enter_business_portal_more_details( business )
  #Watir::Wait::until do
    #@browser.div( :class, 'LiveUI_Area_More_Details_Title' ).exists?
  #end
sleep(7)
  @browser.div( :class, 'LiveUI_Area_Established_Date' ).text_field().set business[ 'year_established' ]
  puts("year stablished")
  @browser.div( :class, 'LiveUI_Area_Description' ).text_field( :index => 0).set business[ 'description' ]
puts("scription")
  @browser.div( :class, 'LiveUI_Area_Languages_spoken' ).text_field().focus
  sleep 4
  #Watir::Wait::until do @browser.div( :text, 'Select' ).exists? end
  #business[ 'languages' ].each{ | language |
    #@browser.div( :text, /#{language}/ ).fire_event( 'onMouseUp' )
  #}
  @browser.div( :class => 'LiveUI_Field_Flag_Option', :index => 8 ).fire_event( 'onMouseUp' )
  @browser.div( :text , 'OK' ).click

  @browser.div( :class, 'LiveUI_Area_Forms_of_payment_accepted' ).text_field().focus
  sleep 4
  #Watir::Wait::until do @browser.div( :class , 'LiveUI_Field_Flag_Option' ).visible? end
  #business[ 'payments' ].each{ | payment |
   # @browser.div( :text, payment ).click
  #}
  @browser.div( :class => 'LiveUI_Field_Flag_Option', :index => 1 ).fire_event( 'onMouseUp' )
  @browser.div( :text , 'OK' ).click

  #@browser.div( :class, 'LiveUI_Area_Business_Hours' ).div( :class, 'LiveUI_Field_Flag' ).click
  #Watir::Wait::until do @browser.div( :text , 'Set Hours' ).visible? end
  #@browser.div( :text , 'Set Hours' ).click

  #if business['open_24_hours'] == true
  #  @browser.div( :id, 'Popup_1||Hours_of Operation||Open24Hours||Open24HoursField' ).click
  #else
  #  @browser.div( :class, 'LiveUI_Area_HoursEntry' ).text_field( :index, 0 ).set business[ 'hours_monday_from' ]
  #  @browser.div( :class, 'LiveUI_Area_HoursEntry' ).text_field( :index, 1 ).set business[ 'hours_monday_to' ]
  #end

  # @browser.div( :text, 'Ok' ).click

  @browser.div( :text, 'Next' ).click
  
end

def enter_business_portal_mobile()
  #Watir::Wait::until do
  #  @browser.div( :text, 'MOBILE SITE' ).exists?
  #end
sleep(5)
  @browser.div( :class, 'LiveUI_Area_FreeMobileSite' ).div( :class, 'LiveUI_Field_Flag' ).click
  @browser.div( :class, 'LiveUI_Area_CreateQRCode' ).div( :class, 'LiveUI_Field_Flag' ).click

  @browser.div( :text, 'Next' ).click
end

def main(business)
  sign_in(business)
  goto_listing(business)
  enter_business_portal_details( business )
  enter_business_portal_more_details( business )

  #Watir::Wait::until do
  #  @browser.div( :class, 'LiveUI_Area_Profile_Title' ).exists?
  #end
  sleep(5)
  @browser.div( :text, 'Next' ).click # skip profile tab
  enter_business_portal_mobile()
  sleep(5)
  #Watir::Wait::until do
   # @browser.div( :text, 'PHOTOS' ).exists?
  #end
  @browser.div( :text, 'Next' ).click # skip photos tab
  sleep(5)
  #Watir::Wait::until do
  #  @browser.div( :class, 'LiveUI_Area_Publish_Title' ).exists?
  #end
  
  @browser.div( :text, 'Next' ).click # skip preview tab
  puts("Trying to verify")
  sleep(5)
  @browser.div( :class, 'LiveUI_Area_Verfiy_Mail_Button LiveUI_Button_Medium' ).click
  puts("verified mailer sent!")
end

main(data)

true
