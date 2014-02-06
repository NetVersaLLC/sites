@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def signin(data) 
  @browser.goto "https://www.manta.com"

  @browser.link(:id => "signin-nav-header").click

  Watir::Wait.until { @browser.div(:class => "login-center").exists? }

  @browser.text_field(:id => "email").set data['email']
  @browser.text_field(:id => "password").set data['password']
  
  @browser.form(:id => "login-form").link(:class => "btn-sign2").click

  throw 'login failed' unless @browser.text.include?('Post an Update')
end 



def find_listing( data ) 
  @browser.text_field(:id => "search-nav-lo").set "#{data['business']} #{data['zip']}"
  @browser.form(:id => 'search-nav-lo-submit').button.click 

  name    = @browser.div(:class => "result-box").a.text 
  address = @browser.div(:class => "result-box").span.text
  puts name 
  puts address
  if name == data['business'] && address == data['address1']
    return  @browser.div(:class => "result-box").a.href
  else 
    return nil
  end 
end 

def create_listing( data )
  @browser.link(:id => 'add-company-link-main-nav').click 

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

  @browser.button( :id, 'SUBMIT').click

  #Watir::Wait.until { @browser.text_field( :id, 'member-firstname').exists? }

  @browser.goto "http://www.manta.com"
  listing_url = @browser.li( :class => 'companyListItem').link.href.gsub(/\?\S*/,"") 
  puts listing_url

  #@browser.text_field( :id, 'member-firstname-preroll').send_keys :enter
  #@browser.text_field( :id, 'member-firstname').when_present.set data[ 'first_name' ]
  #@browser.text_field( :id, 'member-lastname-preroll').send_keys :enter
  #@browser.text_field( :id, 'member-lastname').when_present.set data[ 'last_name' ]
  #@browser.text_field( :id, 'member-email').focus
  #@browser.text_field( :id, 'member-email').set data[ 'email' ]
  #@browser.text_field( :id, 'member-email_confirm').focus
  #@browser.text_field( :id, 'member-email_confirm').set data[ 'email' ]
  #@browser.text_field( :id, 'member-password').focus
  #@browser.text_field( :id, 'member-password').set data[ 'password' ]
  #@browser.text_field( :id, 'member-confirm_password').focus
  #@browser.text_field( :id, 'member-confirm_password').set data[ 'password']


  #uncheck the newsletters
  #@browser.checkbox( :id, 'manta-smb' ).clear
  #@browser.checkbox( :id, 'over-quota' ).clear
  #@browser.link(:class, 'btn-join btn-continue').click

  #@browser.link(:text, /Continue to my profile/).when_present.click
  #@browser.link(:text, /I'll do it later/).when_present.click
  # TODO - Products not yet supported
  #@browser.text_field(:id, "product-selector-autocomplete").when_present.set data['product']
  #@browser.text_field(:id, "product-selector-autocomplete").send_keys :enter
  #@browser.li(:class => "user", :text => data['category']).when_present.click
  #@browser.span(:class => "ui-button-text", :text => "Done").when_present.click
  if @chained
    self.start("Manta/Verify")
  end
  listing_url
end

signin( data )
listing_url =   find_listing(data)
listing_url ||= create_listing(data)
self.save_account("Manta", {:listing_url => listing_url, :status => "Verification needed."})
