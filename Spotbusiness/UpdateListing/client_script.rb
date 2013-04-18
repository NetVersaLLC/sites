sign_in(data)

@browser.goto("http://spotabusiness.com/View-user-details.html")

  @browser.text_field(:name => 'name').set data[ 'full_name' ]
  @browser.text_field(:id => 'username').set data[ 'email' ]
  @browser.text_field(:name => 'password__verify').set data[ 'password' ]
  @browser.text_field(:name => 'password').set data[ 'password' ]
  @browser.text_field(:name => 'company').set data[ 'business' ]
  @browser.text_field(:name => 'address').set data[ 'address' ]
  @browser.text_field(:name => 'city').set data[ 'city' ]
  @browser.select_list(:name => 'cb_statelist').select data[ 'state' ]
  @browser.text_field(:name => 'zipcode').set data[ 'zip' ]
  @browser.text_field(:name => 'cb_phone').set data[ 'phone' ]
  @browser.text_field(:name => 'email').set data[ 'email' ]
  @browser.select_list(:name => 'cb_businesscategory').select data[ 'business_category' ]
  @browser.select_list(:name=> 'cb_profilechoose').select data['profile_type']

@browser.button(:id => 'cbbtneditsubmit').click

Watir::Wait.until { @browser.text.include? 'Your settings have been saved.' }
