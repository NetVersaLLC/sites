
def update_company( data )
  @browser.div(:id => 'o-company').link(:text => 'EDIT').click
  @modal = @browser.div(:class => 'ui-dialog ui-widget ui-widget-content ui-corner-all ui-front ui-dialog-buttons ui-draggable manta-dialog manta-dialog-fancy manta-dialog-claim')
  @modal.text_field(:id => 'claimed.company_name').when_present.set data['business']
  @modal.text_field(:id => 'address1').when_present.set data['address']
  @modal.select_list(:id => 'co_State').when_present.select ['data[ 'stateabreviation' ]
  @modal.text_field(:id => 'co_City').when_present.set data['city']
  @modal.button(:class => 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only').click
  
  @browser.span(:text => 'No, Thanks').click if @browser.span(:text => 'No, Thanks').exist?
  @browser.div(:class => 'edit-overlay-section contact1').link(:text => 'EDIT').click
  @modal.text_field(:id => 'W130 validation_phone').set data ['phone']
  @modal.text_field(:id => 'W130 validation_website').set data ['website']
  @modal.button(:class => 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only').click
  
  @browser.div(:id => 'o-description').link(:text => 'EDIT').click
  @modal.text_field(:class => 'claimed.short_description').set data['business_description']
  @modal.button(:class => 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only').click
  
  @browser.div(:id => 'o-logo').link(:text => 'EDIT').click
  
  # Add logo
  data['logo'] = self.logo
  browser.file_field(:id,"uploaded_file").set data['logo']
  sleep(3)
  @browser.wait_until { @browser.image(:src => 'upload-img-standard').exist? ==false}
  @modal.button(:class => 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only').click
end

def login( data )
  #load the browser and navigate to the business search page
  @browser.goto('http://www.manta.com')
  @browser.text_field(:id => 'login-email').set data['email']
  @browser.text_field(:id => 'login-password').set data['password']
  @browser.link(:text => 'Sign in').click
end

#Main Steps
login( data )
update_company( data )

true
