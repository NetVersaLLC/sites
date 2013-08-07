#Add a company

def add_company( data )

  #select the country
  @browser.select_list( :id => 'co_Country').when_present.select data[ 'country' ]
  #select the state
  @browser.select_list( :id => 'co_State' ).when_present.select data[ 'state' ]

  #enter the rest of the company information
  @browser.text_field( :id, 'co_City').when_present.set data[ 'city' ]
  @browser.text_field( :id, 'co_Name').set data[ 'business' ]
  @browser.text_field( :id, 'co_Address').set data[ 'address' ]
  @browser.text_field( :id, 'co_Phone').set data[ 'phone' ]
  @browser.text_field( :id, 'co_Zip').set data[ 'zip' ]

  #Select the What is your relationship to this company radio group
  @browser.radio( :value, 'owner').set
  @browser.button( :id, 'SUBMIT').fire_event("onClick")
  @browser.button( :id, 'SUBMIT').click

  #fill out member form
  sleep(5)
  @browser.text_field( :id, 'member-firstname-preroll').fire_event("onClick")
  @browser.text_field( :id, 'member-firstname-preroll').when_present.set data[ 'first_name' ]
  @browser.text_field( :id, 'member-lastname-preroll').fire_event("onClick")
  @browser.text_field( :id, 'member-lastname-preroll').when_present.set data[ 'last_name' ]
  @browser.text_field( :id, 'member-email').focus
  @browser.text_field( :id, 'member-email').set data[ 'email' ]
  @browser.text_field( :id, 'member-email_confirm').focus
  @browser.text_field( :id, 'member-email_confirm').set data[ 'email' ]
  @browser.text_field( :id, 'member-password').focus
  @browser.text_field( :id, 'member-password').set data[ 'password' ]
  @browser.text_field( :id, 'member-confirm_password').focus
  @browser.text_field( :id, 'member-confirm_password').set data[ 'password']


  #uncheck the newsletters
  @browser.checkbox( :id, 'manta-smb' ).clear
  @browser.checkbox( :id, 'over-quota' ).clear
  @browser.link(:class, 'btn-join btn-continue').click

  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Manta'
  sleep(5)

  @modal_box = @browser.div(:class => 'ui-dialog ui-widget ui-widget-content ui-corner-all ui-front manta-dialog-fancy fancy-overlay-border get-verified-overlay get-verified-overlay-v2 ui-draggable')
  @browser.wait_until{@modal_box.exist?}
  notify_text = @modal_box.div(:class => 'verify-overlay-copy').text
  # Close modal
  @modal_box.link(:text => 'Close').click
  
  @browser.text_field(:id=>'product-selector-autocomplete').when_present.set data['category']
  @browser.text_field(:id=>'product-selector-autocomplete').send_keys :down
  @browser.text_field(:id=>'product-selector-autocomplete').send_keys :enter
  @browser.div(:id => 'product-selector-suggested').li(:text => data['category']).when_present.click
  @browser.button(:class => 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only').click
end

def main( data )
  #load the browser and navigate to the business search page
  @browser.goto('http://www.manta.com/profile/my-companies/select?add_driver=home-getstarted')
  add_company( data )
end

#Main Steps
main( data )
true
