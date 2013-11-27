def add_business(data)
  @browser.goto("https://www.bizzspot.com/customer_session/new")
  @browser.text_field(:id=> /customer_session_email/).when_present.set data[ 'email' ]
  @browser.text_field(:id=> /customer_session_password/).set data[ 'password' ]
  @browser.button(:value => /Login/).click
  Watir::Wait::until { @browser.text.include? "Welcome" }
  @browser.link(:id => /company_info_link/).click
  Watir::Wait::until { @browser.text.include? "Company Info" }
  @browser.link( :text => /Contact Info/i).click
  @browser.text_field(:id=> /profile_contact_name/).when_present.set data[ 'username' ]
  @browser.text_field(:id=> /profile_contact_phone/).set data[ 'phone' ]
  @browser.link( :text => /Business Info/i).click
  @browser.text_field(:id=> /profile_name/).when_present.set data[ 'first_name' ]
  @browser.text_field(:id=> /profile_address/).set data[ 'address' ]
  @browser.text_field(:id=> /profile_city/).set data[ 'city' ]
  @browser.text_field(:id=> /profile_state/).set data[ 'state' ]
  @browser.text_field(:id=> /profile_zipcode/).set data[ 'zip' ]
  @browser.text_field(:id=> /profile_phone/).set data[ 'phone' ]
  @browser.link( :text => /Hours of Operation/i).click
  @browser.text_field(:id=> /profile_monday_hours/).when_present.set data['monday']
  @browser.text_field(:id=> /profile_tuesday_hours/).set data['tuesday']
  @browser.text_field(:id=> /profile_wednesday_hours/).set data['wednesday']
  @browser.text_field(:id=> /profile_thursday_hours/).set data['thursday']
  @browser.text_field(:id=> /profile_friday_hours/).set data['friday']
  @browser.link( :text => /Payment Methods/i).click
  @browser.checkbox(:value => /Mastercard/).set
  @browser.checkbox(:value => /Cash/).set
  @browser.checkbox(:value => /Check/).set
  @browser.checkbox(:value => /Visa/).set
  @browser.checkbox(:value => /Discover/).clear
  
  @browser.button( :value => /Save/).click

  if Watir::Wait::until { @browser.text.include? "Save successful!" }
    puts "Business update successful"
    self.save_account("bizzspot", {:username => data[ 'username' ], :password => data[ 'password' ], :email => data[ 'email' ]})
    true
  else
    throw "Mislleneous problems."
  end    
end

@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

#~ #Main Steps
add_business(data)