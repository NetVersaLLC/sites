
    
def Login_new_bussiness(data)    
  @browser.text_field(:name => /username/).set data[ 'username' ]
  @browser.text_field(:name => /passwd/).set data[ 'password' ]
  @browser.button(:value => 'Log In').click
end

def Update_Profile_Listing(data)
  @browser.text_field(:name => /passwd/).set data[ 'password' ]
  #Nearest Big City...
  @browser.select_list( :name => 'region').select data['region']
  @browser.select_list( :name => 'gender').select data['gender']
  @browser.text_field(:name => /age/).set data[ 'dob' ]
  @browser.button(:value => 'UPDATE').click

  @confirmation_msg = 'Profile successfully updated'
        
  if @browser.text.include?(@confirmation_msg)
    puts "Job returned true!"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ],'model' => 'Yellowtalk'
    true
    else
    throw "Job failed!"
  end
end

#~ #Main Steps
#~ # Launch browser
@url = 'http://yellowtalk.com/login_page.php'
@browser.goto(@url)
Login_new_bussiness(data)
@browser.wait
@url = 'http://yellowtalk.com/member_profile.php'
@browser.goto(@url)
#Move on to the update the profile
Update_Profile_Listing(data)
@browser.close
exit