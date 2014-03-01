@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}

def sign_in_business( data )
  @browser.goto('https://login.live.com') 
  @browser.text_field(:name => "login").set data['hotmail']
  @browser.text_field(:name => "passwd").set data['password']
  @browser.button(:value => "Sign in").click 

  @browser.goto( 'https://www.bingplaces.com/' )
  @browser.button(:id => 'loginButton').click
  sleep 2
  @browser.link(:text => 'Login').click
  sleep(5)
  @browser.goto( 'https://www.bingplaces.com/dashboard')
  @browser.h3(:text => /Find your business/).wait_until_present
end

def search_and_claim_business( data )

  @browser.text_field(:name => 'BusinessName').set data['business']
  @browser.text_field(:name => 'City').set data['city'] + ", " + data['state_short']
  @browser.button(:value => 'Search').click

  puts @browser.ready_state 
  puts @browser.status 
  3.times do 
    sleep(10)
    puts @browser.ready_state 
    puts @browser.status 
    break if @browser.h5(:text => "Search Results").exist? 
    break if @browser.span(:text => /found no businesses/).exist? 
  end 

  if @browser.h5(:text => "Search Results").exist? 
    @browser.ul(:class => "sideMenu").lis.each do |li|
      result = li.text.downcase.gsub(/\.*,*/, "")
      name = data['business'][0..10].downcase.gsub(/\.*,*/, "")
      address = data['address'][0..10].downcase.gsub(/\.*,*/, "")

      if result.include?(name) || result.include?(address)
        li.button(:value => "Select").click
        Watir::Wait.until { @browser.h4(:text => /Tell us about your business/).exist? } 
        return true
      end
    end 
  end 
  return false 
end


def update_listing( data )
  sleep 2
  @browser.execute_script("hidePopUp()")
  sleep 2
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').when_present.clear
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').set data['business']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine1').set data['address']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine2').set data['address2']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').set data['city']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.State.StateName').set data['state_name']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.ZipCode').set data['zip']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessEmailAddress').set data['hotmail']
  @browser.text_field(:name => 'BasicBusinessInfo.WebSite').set data['website']

  category = data['category'] 
  set_checkbox_for_category = "document.evaluate(\"//text()[contains(.,'#{category}')]\",document, null, XPathResult.ANY_TYPE, null).iterateNext().parentElement.previousElementSibling.checked = true;"

  @browser.text_field(:id => "categoryInputTextBox").set category
  @browser.button(:id => "categoryAddButton").click 
  @browser.execute_script( set_checkbox_for_category )  # set a checkbox that is not visible, which watir does not allow
  @browser.button(:text => "Add").click 

  sleep(60)

  @browser.button(:id => 'submitBusiness').click
  sleep(60)

  @browser.element(:css => '.middlePane > div:nth-child(2) > input:nth-child(7)').when_present.click
  sleep(60)
end

sign_in_business( data )
if search_and_claim_business( data )
  update_listing( data )
  if @chained
    self.start("Bing/AdditionalDetails")
  end
else 
  if @chained
    self.start("Bing/CreateListing")
  end
  self.failure("Could not find a business to claim") 
end 

