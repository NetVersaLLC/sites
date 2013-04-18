def add_new_listing( business )

  puts 'Add new listing'
  watir_must do @browser.div( :text, 'Add new listing' ).click end
  watir_must do @browser.div( :class, 'Dialog_TitleContainer' ).exists? end
  #sleep 4 # because fails to wait
  puts '=== Done -> Watir::Wait::until do @browser.div( Dialog_TitleContainer ).exists?'

  # Note that business name, city, state and country are already populated.
  # Only USA as coutry is allowed at the time of this writing.
  # TODO: try focusing on fields first if it thinks they are blank
  
  addres_field = @browser.div(:class, 'LiveUI_Area_Confirm___Address').text_field()
  addres_field.focus
  addres_field.click
  addres_field.set business[ 'address' ]

  zip_field = @browser.div(:class, 'LiveUI_Area_Confirm___ZipCode').text_field()
  zip_field.focus
  zip_field.click
  zip_field.set business[ 'zip' ]

  phone_field = @browser.div(:class, 'LiveUI_Area_Confirm___Phone').text_field()
  phone_field.focus
  phone_field.click
  phone_field.set business[ 'phone' ]

  #captcha_text = solve_captcha( :add_listing )
  captcha_field = @browser.div(:class, 'LiveUI_Area_Picture_Password_Verification').text_field()
  # @browser.input( :name, /Widget_AuthentifyField/ )
  captcha_field.focus
  captcha_field.flash
  captcha_field.click #captcha_field.clear
  sleep 1
  captcha_field.fire_event( 'onkeypress' )
  sleep 1
	enter_captcha3
  #@browser.div( :text, 'Ok' ).focus
  #@browser.div( :text, 'Ok' ).click
true
end

def enter_personal_contact_info( business )

puts("before the wait")
  # TODO: handle the case that personal info may be entered already and 'YOUR BUSINESS INFORMATION' page opens
  sleep(5)
    #Watir::Wait.until { @browser.div( :id => /Contact_title/).exists? } #:class => LiveUI_Area_Contact_title
  
puts("Past the wait")

  @browser.div( :class, 'LiveUI_Area_Phone_number' ).text_field().set business[ 'phone' ]
  @browser.div( :class, 'LiveUI_Area_Confirm_Email_address1' ).text_field().set business[ 'hotmail' ]

  @browser.div( :class, 'LiveUI_Area_Agreement_of_Terms_and_Conditions' ).div( :class, 'LiveUI_Field_Flag' ).div().fire_event( 'onMouseDown' )
  @browser.div( :class, 'LiveUI_Area_Agreement_of_Terms_and_Conditions' ).div( :class, 'LiveUI_Field_Flag' ).div().fire_event( 'onMouseUp' )
  @browser.div( :class, 'LiveUI_Area_Bing_Portal_Announcement_Subscription' ).div( :class, 'LiveUI_Field_Flag' ).div().fire_event( 'onMouseDown' )
  @browser.div( :class, 'LiveUI_Area_Bing_Portal_Announcement_Subscription' ).div( :class, 'LiveUI_Field_Flag' ).div().fire_event( 'onMouseUp' )
  @browser.div( :class, 'LiveUI_Area_btnAccept LiveUI_Button_Medium' ).click #watir_must do

end

sign_in( data )
search_for_business( data )
add_new_listing( data )
enter_personal_contact_info( data )

if @chained
  self.start("Bing/Update")
end

true
