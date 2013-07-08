
    
def Login_new_bussiness(data)    
  @url = 'http://yellowtalk.com/login_page.php'
  @browser.goto(@url)
  @browser.text_field(:name => /username/).when_present.set data[ 'username' ]
  @browser.text_field(:name => /passwd/).set data[ 'password' ]
  @browser.button(:value => 'Log In').click
end

def Update_Profile_Listing(data)
  @url = 'http://yellowtalk.com/mybusiness.php'
  @browser.goto(@url)
  @browser.link(:text=>'Edit this listing').when_present.click
  #@browser.text_field(:name => /passwd/).set data[ 'password' ]
  #Nearest Big City...
  

  @browser.select_list(:name => "category[0]").when_present.select data[ 'category' ]
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
  @browser.button(:value => 'Update My Listing Now!').click
  
  #Check for confirmation
  # file origin.rb

  #Below is the text the is included in the browser when the registration is successfull.
  Watir::Wait.until { @browser.text.include? 'Free Listings...' }
  @confirmation_msg ="Free Listings..."

  if @browser.text.include? @confirmation_msg
    #puts "Job returned true!"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ],'model' => 'Yellowtalk'
    true
    else
    throw "Job failed!"
  end
end

#~ #Main Steps
#~ # Launch browser
Login_new_bussiness(data)
#Move on to the update the profile
Update_Profile_Listing(data)