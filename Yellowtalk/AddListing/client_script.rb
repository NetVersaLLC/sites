require 'watir-webdriver'
def add_new_business(data)
  #Added the username as it is the first one in the list...
  @browser.text_field(:name => /ownerusername/).when_present.set data[ 'username' ]
  @browser.text_field(:name => /ownerpassword/).set data[ 'password' ]
  @browser.text_field(:name => /ownerusername_c/).set data[ 'username' ]
  @browser.text_field(:name => /ownerpassword_c/).set data[ 'password' ]
  @browser.text_field(:name => /owneremail/).set data[ 'email' ]
  @browser.select_list(:name => "category[0]").select data[ 'category' ]
  #@browser.select_list(:name => /category[1]/).select data[ 'keywords' ]
  #@browser.select_list(:name => /category[2]/).select data[ 'keywords' ]
  @browser.text_field(:name => /title/).set data[ 'name_title' ]
  @browser.text_field(:name => /companyname/).set data[ 'business' ]
  @browser.text_field(:name => /firstname/).set data[ 'first_name' ]
  @browser.text_field(:name => /lastname/).set data[ 'last_name' ]
  @browser.text_field(:name => /address/).set data[ 'address' ]
  @browser.text_field(:name => /city/).set data[ 'city' ]
  @browser.select_list(:name => /state/).select data[ 'state' ]
  @browser.text_field(:name => /zip/).set data[ 'zip' ]
  @browser.text_field(:name => /phone/).set data[ 'phone' ]
  @browser.button(:value => 'Add My Listing Now!').click

  
  #Check for confirmation
 
  #Below is the text the is included in the browser when the registration is successfull.
  Watir::Wait.until { @browser.text.include? 'Thank you for submitting your listing.' }
  @success_text ="Thank you for submitting your listing."



  if @browser.text.include? @success_text
    puts "Business has been claimed successful"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ], 'account[password]' => data['password'], 'account[username]' => data['username'], 'model' => 'Yellowtalk'
    #self.save_account("yellowtalk", {:username => data[ 'username' ], :password => data[ 'password' ], :email => data[ 'email' ]})
    return true
  else
    throw "Business has not been claimed successful"
  end  
end
    
#~ #Main Steps
@url = 'http://yellowtalk.com/businessFreeAdd.php'
@browser.goto(@url)
add_new_business(data)