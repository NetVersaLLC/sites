def add_new_listing( data )


@browser.execute_script("hidePopUp()")

  puts 'Add new listing'
  sleep 2
  @browser.button( :text, 'Add New Business' ).when_present.click
retries = 3
begin
  sleep 2
  @browser.execute_script("hidePopUp()")
  sleep 2
  Watir::Wait.until { @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').exists? }
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').clear
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').set data['business']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine1').set data['address']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine2').set data['address2']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').set data['city']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.State.StateName').set data['state_name']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.ZipCode').set data['zip']
  @browser.text_field(:name => 'BasicBusinessInfo.MainPhoneNumber.PhoneNumberField').set data['local_phone']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessEmailAddress').set data['hotmail']
  @browser.text_field(:name => 'BasicBusinessInfo.WebSite').set data['website']

  if @browser.element(:css , "a[onclick='removeBusinessCategory(this)']").exists?
    @browser.elements(:css , "a[onclick='removeBusinessCategory(this)']").each do |close|
      close.to_subtype.click
    end
  end

  @browser.text_field(:id => 'categoryInputTextBox').set data['category']
  sleep(9 - retries)
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
  sleep(6 - retries)
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :enter
  sleep(6 - retries)
  @browser.button(:id => 'categoryAddButton').click
  sleep(5 - retries)
  @browser.button(:id => 'submitBusiness').click

  sleep(4 - retries)
  @browser.button(:value => 'Verify Later').when_present.click

  sleep(4 - retries)
  Watir::Wait.until { @browser.text.include? "Manage Your Listings" }
rescue Exception => e
  puts(e.inspect)
  if retries > 0
    puts("Something went wrong, trying again in 2 seconds..")
    sleep 2
    retries -= 1
    retry
  else
    throw e.inspect
  end
end

  true

end

sign_in_business( data )

if not search_for_business( data )

  add_new_listing( data )

  if @chained
    self.start("Bing/AdditionalDetails")
  end
  true
else
  puts("business found, attempting to claim")
  if @chained
    self.start("Bing/ClaimListing")
  end
  true
end
