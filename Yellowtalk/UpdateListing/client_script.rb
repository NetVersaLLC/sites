def Login_new_bussiness(data)    
  @url = 'http://yellowtalk.com/login_page.php'
  @browser.goto(@url)
  30.times{ break if @browser.status == "Done"; sleep 1}
  @browser.text_field(:name => /username/).when_present.set data[ 'username' ]
  @browser.text_field(:name => /passwd/).set data[ 'password' ]
  @browser.button(:value => 'Log In').click
  30.times{ break if @browser.status == "Done"; sleep 1}
end

def Update_Profile_Listing(data)
  @url = 'http://yellowtalk.com/mybusiness.php'
  @browser.goto(@url)
  30.times{ break if @browser.status == "Done"; sleep 1}
  @browser.link(:text=>'Edit this listing').when_present.click
  30.times{ break if @browser.status == "Done"; sleep 1}

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
  @browser.text_field(:name => /fax/).set data [ 'fax' ]
  @browser.text_field(:name => /email/).set data [ 'email' ]
  @browser.button(:value => 'Update My Listing Now!').click
  
  30.times{ break if @browser.status == "Done"; sleep 1}
  Watir::Wait.until { @browser.text.include? 'Free Listings...' }
  @confirmation_msg ="Free Listings..."

  if @browser.text.include? @confirmation_msg
    puts "Business listing updated."    
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